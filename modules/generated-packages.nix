# Generated Packages Module for Zeus Wheels
# Automatically exposes wheel packages based on configuration
{
  self,
  config,
  lib,
  flake-parts-lib,
  ...
}: let
  inherit (flake-parts-lib) mkPerSystemOption;
  inherit (lib) mapAttrs' genAttrs concatMapAttrs;
  cfg = config.wheels;
in {
  options.perSystem = mkPerSystemOption ({
    config,
    pkgs,
    system,
    ...
  }: {
    options.wheels.packages = lib.mkOption {
      type = lib.types.attrsOf lib.types.package;
      default = {};
      description = "Generated wheel packages";
    };
  });

  config.perSystem = {
    pkgs,
    system,
    self',
    inputs',
    ...
  }: let
    # Apply our overlay to get wheel packages
    # Use the overlay function directly
    pkgsWithWheels = pkgs.extend self.overlays.default;

    # Get packages for current platform
    platformPackages = cfg.generated.packagesByPlatform.${system} or {};
    universalPackages = cfg.generated.packagesByPlatform.universal or {};

    # Add custom packages as exportable packages
    customPackages =
      lib.mapAttrs (name: spec: {
        python_versions = spec.pythonVersions;
        # Custom packages don't have the same structure as generated packages
        # but we need this for the generatePackageSet function
      })
      cfg.customPackages;

    allPackages = platformPackages // universalPackages // customPackages;

    # Generate package derivations for each Python version
    generatePackageSet =
      mapAttrs' (
        packageName: spec: let
          pythonPackages = genAttrs spec.python_versions (
            pythonVer:
              pkgsWithWheels."python${pythonVer}Packages".${packageName} or null
          );

          # Create individual versioned packages
          versionedPackages = mapAttrs' (pythonVer: pkg: {
            name = "${packageName}-python${pythonVer}";
            value = pkg;
          }) (lib.filterAttrs (name: pkg: pkg != null) pythonPackages);

          # Create a default package (latest Python)
          defaultPkg = pythonPackages."313" or pythonPackages."312" or pythonPackages."311" or null;
        in {
          name = packageName;
          value =
            versionedPackages
            // (lib.optionalAttrs (defaultPkg != null) {
              "${packageName}" = defaultPkg;
            });
        }
      )
      allPackages;

    # Flatten to individual packages
    flattenedPackages = concatMapAttrs (packageName: versionedPkgs: versionedPkgs) generatePackageSet;

    # Additional utility packages
    utilityPackages = {
      # Wheel generator with current config
      wheel-generator = pkgs.writeShellScriptBin "wheel-generator" ''
        exec ${pkgs.python3}/bin/python ${../nix_wheel_generator.py} "$@"
      '';

      # Config inspector - shows current wheel configuration
      wheel-config = let
        # Filter out function attributes for JSON serialization
        serializablePackages =
          mapAttrs' (name: spec: {
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
        pkgs.writeText "wheel-config.json"
        (builtins.toJSON {
          sources = cfg.sources;
          packages = serializablePackages;
          generated = {
            testCount = builtins.length cfg.generated.testMatrix;
            packagesByPlatform =
              mapAttrs' (platform: packages: {
                name = platform;
                value = lib.attrNames packages;
              })
              cfg.generated.packagesByPlatform;
            wheelCommands =
              mapAttrs' (source: cmd: {
                name = source;
                value = cmd.command;
              })
              cfg.generated.wheelCommands;
          };
        });

      # Command generator - creates shell scripts for wheel generation
      generate-wheels = pkgs.writeShellScriptBin "generate-wheels" ''
        set -euo pipefail

        echo "🎯 Generating wheels for all configured sources..."
        echo

        ${lib.concatStringsSep "\n" (lib.mapAttrsToList (sourceName: cmdInfo: ''
            echo "📦 Generating wheels from ${sourceName}..."
            echo "   Command: ${lib.concatStringsSep " " cmdInfo.command}"
            echo "   Packages: ${lib.concatStringsSep ", " cmdInfo.wheelNames}"

            # Run the actual generation
            ${lib.concatStringsSep " " cmdInfo.command} --output-dir ./generated/${sourceName}
            echo "   ✅ ${sourceName} wheels generated"
            echo
          '')
          cfg.generated.wheelCommands)}

        echo "🎉 All wheel generation completed!"
      '';

      # Development shell with all wheels available
      wheel-shell = pkgs.mkShell {
        buildInputs = [
          pkgsWithWheels.python311
          pkgsWithWheels.python312
          pkgsWithWheels.python313
        ];

        shellHook = ''
          echo "🐍 Zeus Wheels Development Shell"
          echo "Available Python versions: 3.11, 3.12, 3.13"
          echo
          echo "📦 Available wheel packages:"
          ${lib.concatStringsSep "\n" (map (
            pkgName: "echo '   ${pkgName}'"
          ) (lib.attrNames (platformPackages // universalPackages)))}
          ${lib.optionalString (cfg.customPackages != {}) ''
            echo
            echo "🔧 Available custom packages:"
            ${lib.concatStringsSep "\n" (map (
              pkgName: "echo '   ${pkgName} (import as: ${cfg.customPackages.${pkgName}.tests.moduleName})'"
            ) (lib.attrNames cfg.customPackages))}
          ''}
          echo
          ${lib.optionalString ((lib.attrNames (platformPackages // universalPackages)) != []) ''
            echo "💡 Try: python -c 'import ${lib.head (lib.attrNames (platformPackages // universalPackages))}'"
          ''}
          ${lib.optionalString (cfg.customPackages != {}) ''
            echo "💡 Try custom: python -c 'import ${lib.head (lib.mapAttrsToList (name: spec: spec.tests.moduleName) cfg.customPackages)}'"
          ''}
        '';
      };
    };
  in {
    wheels.packages = flattenedPackages // utilityPackages;

    # Add to main packages output
    packages =
      flattenedPackages
      // utilityPackages
      // {
        # Default package points to wheel generator
        default = utilityPackages.wheel-generator;
      };

    # Legacy packages for backward compatibility
    legacyPackages =
      {
        # Python with wheel packages available
        python311WithWheels = pkgsWithWheels.python311;
        python312WithWheels = pkgsWithWheels.python312;
        python313WithWheels = pkgsWithWheels.python313;
      }
      // (
        # Individual package access (legacy format)
        concatMapAttrs (
          packageName: spec:
            genAttrs spec.python_versions (
              pythonVer:
                pkgsWithWheels."python${pythonVer}Packages".${packageName} or null
            )
            // {
              # Legacy format: packagename311, packagename312, etc.
              "${packageName}311" = pkgsWithWheels.python311Packages.${packageName} or null;
              "${packageName}312" = pkgsWithWheels.python312Packages.${packageName} or null;
              "${packageName}313" = pkgsWithWheels.python313Packages.${packageName} or null;
            }
        )
        allPackages
      );
  };
}
