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

    # Helper function to get effective Python versions for any package
    getEffectivePythonVersions = packageName: packageSpec:
      if builtins.hasAttr "python_versions" packageSpec
      then
        if packageSpec.python_versions == [] then cfg.pythonVersions else packageSpec.python_versions
      else
        if packageSpec.pythonVersions == [] then cfg.pythonVersions else packageSpec.pythonVersions;

    # Add custom packages as exportable packages
    customPackages =
      lib.mapAttrs (name: spec: {
        python_versions = getEffectivePythonVersions name spec;
        # Custom packages don't have the same structure as generated packages
        # but we need this for the generatePackageSet function
      })
      cfg.customPackages;

    # Update platform packages to use effective Python versions
    effectivePlatformPackages =
      lib.mapAttrs (name: spec:
        spec // {
          python_versions = getEffectivePythonVersions name spec;
        })
      platformPackages;

    effectiveUniversalPackages =
      lib.mapAttrs (name: spec:
        spec // {
          python_versions = getEffectivePythonVersions name spec;
        })
      universalPackages;

    allPackages = effectivePlatformPackages // effectiveUniversalPackages // customPackages;

    # Generate package derivations for each Python version
    generatePackageSet =
      mapAttrs' (
        packageName: spec: let
          # Check if this is a custom package
          isCustomPackage = cfg.customPackages ? ${packageName};
          
          pythonPackages = 
            if isCustomPackage
            then 
              # For custom packages, call the definition function
              genAttrs spec.python_versions (
                pythonVer: 
                  cfg.customPackages.${packageName}.definition {
                    pkgs = pkgs;
                    python3Packages = pkgsWithWheels."python${pythonVer}Packages";
                  }
              )
            else
              # For wheel packages, look them up in the Python package sets
              genAttrs spec.python_versions (
                pythonVer:
                  pkgsWithWheels."python${pythonVer}Packages".${packageName} or null
              );

          # Create individual versioned packages
          versionedPackages = mapAttrs' (pythonVer: pkg: {
            name = "${packageName}-python${pythonVer}";
            value = pkg;
          }) (lib.filterAttrs (name: pkg: pkg != null) pythonPackages);

          # Create a default package (latest Python from configured versions)
          latestVersion = lib.last (lib.sort (a: b: a < b) cfg.pythonVersions);
          defaultPkg = pythonPackages.${latestVersion} or null;
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
        exec ${lib.getExe pkgs.python3} ${../nix_wheel_generator.py} "$@"
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
        buildInputs = map (version: pkgsWithWheels."python${version}") cfg.pythonVersions;

        shellHook = ''
          echo "🐍 Zeus Wheels Development Shell"
          echo "Available Python versions: ${lib.concatMapStringsSep ", " (v: "3.${lib.substring 1 1 v}.${lib.substring 2 1 v}") cfg.pythonVersions}"
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
      (builtins.listToAttrs (
        map (version: {
          name = "python${version}WithWheels";
          value = pkgsWithWheels."python${version}";
        }) cfg.pythonVersions
      ))
      // (
        # Individual package access (legacy format)
        concatMapAttrs (
          packageName: spec: let
            # Check if this is a custom package
            isCustomPackage = cfg.customPackages ? ${packageName};
            
            # Create dynamic legacy format packages based on global pythonVersions
            legacyFormatPackages = builtins.listToAttrs (
              map (version: {
                name = "${packageName}${version}";
                value = 
                  if isCustomPackage
                  then 
                    cfg.customPackages.${packageName}.definition {
                      pkgs = pkgs;
                      python3Packages = pkgsWithWheels."python${version}Packages";
                    }
                  else
                    pkgsWithWheels."python${version}Packages".${packageName} or null;
              }) cfg.pythonVersions
            );
          in
            genAttrs spec.python_versions (
              pythonVer:
                if isCustomPackage
                then 
                  cfg.customPackages.${packageName}.definition {
                    pkgs = pkgs;
                    python3Packages = pkgsWithWheels."python${pythonVer}Packages";
                  }
                else
                  pkgsWithWheels."python${pythonVer}Packages".${packageName} or null
            )
            // legacyFormatPackages
        )
        allPackages
      );
  };
}
