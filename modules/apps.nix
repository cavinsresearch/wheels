# Apps Module for Zeus Wheels
# Provides flake applications for wheel generation and management
{
  config,
  lib,
  flake-parts-lib,
  ...
}: let
  inherit (flake-parts-lib) mkPerSystemOption;
  inherit (lib) mapAttrs' concatStringsSep mapAttrsToList;
  cfg = config.wheels;
in {
  options.perSystem = mkPerSystemOption ({
    config,
    pkgs,
    system,
    ...
  }: {
    options.wheels.apps = lib.mkOption {
      type = lib.types.attrsOf lib.types.unspecified;
      default = {};
      description = "Generated wheel applications";
    };
  });

  config.perSystem = {
    config,
    pkgs,
    system,
    ...
  }: let
    # Generate configuration file for wheel generator
    wheelGeneratorConfig = let
      # Filter out function attributes for JSON serialization
      serializablePackages =
        lib.mapAttrs' (name: spec: {
          name = name;
          value =
            lib.filterAttrs (
              attrName: attrValue:
              # Exclude function attributes from serialization
                !(lib.isFunction attrValue)
            )
            spec;
        })
        cfg.packages;
    in
      pkgs.writeText "wheel-generator-config.json" (builtins.toJSON {
        sources = cfg.sources;
        packages = serializablePackages;
      });

    # Generate wheel generation script for all sources
    generateAllWheelsScript = pkgs.writeShellScript "generate-all-wheels" ''
      set -euo pipefail

      echo "🎯 Zeus Wheels Generator"
      echo "======================="
      echo "Generating wheels for all configured sources..."
      echo

      # Create output directory
      OUTPUT_DIR="''${OUTPUT_DIR:-./generated}"
      mkdir -p "$OUTPUT_DIR"
      echo "📁 Output directory: $OUTPUT_DIR"
      echo

      ${concatStringsSep "\n" (mapAttrsToList (sourceName: cmdInfo: ''
          echo "📦 Generating wheels from ${sourceName}..."
          echo "   Packages: ${concatStringsSep ", " cmdInfo.wheelNames}"
          echo "   Command: wheel-generator --config ${wheelGeneratorConfig} --source ${sourceName} --packages ${concatStringsSep "," cmdInfo.wheelNames} --version-limit ${toString cfg.sources.${sourceName}.default_version_limit}"

          # Run the actual generation
          SOURCE_OUTPUT="$OUTPUT_DIR/${sourceName}"
          mkdir -p "$SOURCE_OUTPUT"

          cd "$SOURCE_OUTPUT"
          ${config.wheels.python.wheelGeneratorEnv}/bin/python ${../nix_wheel_generator.py} --config ${wheelGeneratorConfig} --source ${sourceName} --packages ${concatStringsSep "," cmdInfo.wheelNames} --version-limit ${toString cfg.sources.${sourceName}.default_version_limit} --output-dir . "$@"
          cd - > /dev/null

          echo "   ✅ ${sourceName} wheels generated in $SOURCE_OUTPUT"
          echo
        '')
        cfg.generated.wheelCommands)}

      echo "🎨 Formatting generated Nix files..."
      find "$OUTPUT_DIR" -name "*.nix" -type f -exec ${pkgs.alejandra}/bin/alejandra {} \;
      echo "✨ Formatting complete!"
      echo

      echo "🎉 All wheel generation completed!"
      echo "📁 Results available in: $OUTPUT_DIR"

      # Show summary
      echo
      echo "📊 Generation Summary:"
      find "$OUTPUT_DIR" -name "*.nix" -type f | while read -r file; do
        count=$(grep -c "buildPythonPackage" "$file" 2>/dev/null || echo "0")
        echo "   $(basename "$(dirname "$file")")/$(basename "$file"): $count packages"
      done
    '';

    # Individual source generation scripts
    generateSourceScripts =
      mapAttrs' (sourceName: cmdInfo: {
        name = sourceName;
        value = pkgs.writeShellScript "generate-${sourceName}-wheels" ''
          set -euo pipefail

          echo "📦 Zeus Wheels Generator - ${sourceName}"
          echo "=================================="
          echo "Generating wheels from ${sourceName} source..."
          echo "Packages: ${concatStringsSep ", " cmdInfo.wheelNames}"
          echo

          # Create output directory
          OUTPUT_DIR="''${OUTPUT_DIR:-./generated/${sourceName}}"
          mkdir -p "$OUTPUT_DIR"
          echo "📁 Output directory: $OUTPUT_DIR"
          echo

          # Run the generation
          cd "$OUTPUT_DIR"
          ${config.wheels.python.wheelGeneratorEnv}/bin/python ${../nix_wheel_generator.py} --config ${wheelGeneratorConfig} --source ${sourceName} --packages ${concatStringsSep "," cmdInfo.wheelNames} --version-limit ${toString cfg.sources.${sourceName}.default_version_limit} --output-dir . "$@"
          cd - > /dev/null

          echo "🎨 Formatting generated Nix files..."
          find "$OUTPUT_DIR" -name "*.nix" -type f -exec ${pkgs.alejandra}/bin/alejandra {} \;
          echo "✨ Formatting complete!"
          echo

          echo "✅ ${sourceName} wheels generated successfully!"
          echo "📁 Results available in: $OUTPUT_DIR"

          # Show what was generated
          echo
          echo "📋 Generated files:"
          find "$OUTPUT_DIR" -name "*.nix" -type f | while read -r file; do
            count=$(grep -c "buildPythonPackage" "$file" 2>/dev/null || echo "0")
            echo "   $(basename "$file"): $count packages"
          done
        '';
      })
      cfg.generated.wheelCommands;

    # Config inspection script
    configInspectorScript = pkgs.writeShellScript "inspect-wheel-config" ''
      set -euo pipefail

      echo "🔍 Zeus Wheels Configuration Inspector"
      echo "====================================="
      echo

      echo "📋 Sources:"
      ${concatStringsSep "\n" (mapAttrsToList (sourceName: sourceConfig: ''
          echo "   ${sourceName}:"
          echo "     URL: ${sourceConfig.base_url}"
          echo "     Version Limit: ${toString sourceConfig.default_version_limit}"
          echo "     Full URLs: ${
            if sourceConfig.use_full_url
            then "yes"
            else "no"
          }"
        '')
        cfg.sources)}
      echo

      echo "📦 Packages:"
      ${concatStringsSep "\n" (mapAttrsToList (packageName: packageSpec: ''
          echo "   ${packageName}:"
          echo "     Source: ${packageSpec.source}"
          echo "     Platforms: ${concatStringsSep ", " packageSpec.platforms}"
          echo "     Python Versions: ${concatStringsSep ", " packageSpec.python_versions}"
          echo "     Tests: ${concatStringsSep ", " packageSpec.tests}"
          echo "     Wheel Name: ${packageSpec.wheel_name}"
        '')
        (lib.mapAttrs (
            name: spec:
              lib.filterAttrs (attrName: attrValue: !(lib.isFunction attrValue)) spec
          )
          cfg.packages))}
      echo

      echo "🧪 Test Matrix:"
      echo "   Total Tests: ${toString (builtins.length cfg.generated.testMatrix)}"
      echo "   Platform Tests for ${system}:"
      ${concatStringsSep "\n" (map (
          test: "echo '     ${test.name}'"
        ) (builtins.filter (
            test:
              lib.elem system test.spec.platforms || lib.elem "universal" test.spec.platforms
          )
          cfg.generated.testMatrix))}
      echo

      echo "⚙️  Configuration File:"
      echo "   Location: ${wheelGeneratorConfig}"
      echo "   Contents:"
      cat ${wheelGeneratorConfig} | ${pkgs.jq}/bin/jq '.'
      echo

      echo "⚙️  Generation Commands:"
      ${concatStringsSep "\n" (mapAttrsToList (sourceName: cmdInfo: ''
          echo "   ${sourceName}: wheel-generator --config ${wheelGeneratorConfig} --source ${sourceName} --packages ${concatStringsSep "," cmdInfo.wheelNames} --version-limit ${toString cfg.sources.${sourceName}.default_version_limit}"
        '')
        cfg.generated.wheelCommands)}
    '';

    # All apps
    wheelApps =
      {
        # Main wheel generation app
        generate-wheels = {
          type = "app";
          program = "${generateAllWheelsScript}";
          meta.description = "Generate all Python wheels from configured sources";
        };

        # Config inspector app
        inspect-config = {
          type = "app";
          program = "${configInspectorScript}";
          meta.description = "Inspect wheel generator configuration and package specifications";
        };

        # Wheel generator tool (direct access with config)
        wheel-generator = {
          type = "app";
          program = "${pkgs.writeShellScript "wheel-generator-wrapper" ''
            exec ${config.wheels.python.wheelGeneratorEnv}/bin/python ${../nix_wheel_generator.py} --config ${wheelGeneratorConfig} "$@"
          ''}";
          meta.description = "Direct access to the wheel generator tool with pre-configured settings";
        };
      }
      // (
        # Individual source generation apps
        mapAttrs' (sourceName: script: {
          name = "generate-${sourceName}";
          value = {
            type = "app";
            program = "${script}";
            meta.description = "Generate Python wheels from ${sourceName} source";
          };
        })
        generateSourceScripts
      );
  in {
    wheels.apps = wheelApps;
    apps =
      wheelApps
      // {
        # Set default app to generate-wheels
        default = wheelApps.generate-wheels;
      };
  };
}
