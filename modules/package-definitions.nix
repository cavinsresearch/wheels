# Package Definitions Module for Zeus Wheels
# Provides type-safe package specifications and source configurations
{
  lib,
  flake-parts-lib,
  ...
}: let
  inherit (lib) types mkOption;
  inherit (flake-parts-lib) mkPerSystemOption;
in {
  options = {
    # Configuration for generated files location
    wheels.generatedPath = mkOption {
      type = types.path;
      default = ../generated;
      description = "Path to the generated packages directory";
    };

    # Global package sources configuration
    wheels.sources = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          base_url = mkOption {
            type = types.str;
            description = "Base URL for the package index";
          };
          default_version_limit = mkOption {
            type = types.ints.positive;
            default = 1;
            description = "Default number of versions to keep per package";
          };
          use_full_url = mkOption {
            type = types.bool;
            default = true;
            description = "Whether URLs are absolute or relative to base_url";
          };
        };
      });
      default = {};
      description = "Package source configurations";
    };

    # Package specifications
    wheels.packages = mkOption {
      type = types.attrsOf (types.submodule ({name, ...}: {
        options = {
          source = mkOption {
            type = types.str;
            description = "Source name (must exist in wheels.sources)";
          };

          platforms = mkOption {
            type = types.listOf (types.enum [
              "aarch64-darwin"
              "aarch64-linux"
              "x86_64-linux"
              "universal"
            ]);
            description = "Supported platforms for this package";
          };

          python_versions = mkOption {
            type = types.listOf (types.enum ["311" "312" "313"]);
            default = ["311" "312" "313"];
            description = "Supported Python versions";
          };

          tests = mkOption {
            type = types.listOf (types.enum [
              "import"
              "abi"
              "runtime"
              "metadata"
              "integration"
              "isolation"
            ]);
            default = ["import"];
            description = "Test types to generate for this package";
          };

          version_limit = mkOption {
            type = types.nullOr types.ints.positive;
            default = null;
            description = "Override default version limit for this package";
          };

          wheel_name = mkOption {
            type = types.str;
            default = name;
            description = "Wheel package name (defaults to attribute name)";
          };

          module_name = mkOption {
            type = types.str;
            default = name;
            description = "Python module name for import testing (defaults to package name)";
          };

          test_dependencies = mkOption {
            type = types.functionTo (types.listOf types.package);
            default = ps: [];
            description = "Function that takes python package set and returns list of test dependencies";
          };
        };
      }));
      default = {};
      description = "Package specifications";
    };

    # Generated outputs (computed from the above)
    wheels.generated = mkOption {
      type = types.submodule {
        options = {
          testMatrix = mkOption {
            type = types.listOf types.unspecified;
            readOnly = true;
            description = "Generated test matrix";
          };

          packagesByPlatform = mkOption {
            type = types.attrsOf (types.attrsOf types.unspecified);
            readOnly = true;
            description = "Packages organized by platform";
          };

          wheelCommands = mkOption {
            type = types.attrsOf types.unspecified;
            readOnly = true;
            description = "Generated wheel generator commands";
          };
        };
      };
      readOnly = true;
      description = "Generated outputs (read-only)";
    };
  };
}
