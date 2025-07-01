# Custom Packages Module for Zeus Wheels
# Provides support for custom Python package definitions that get included in the overlay
{
  lib,
  flake-parts-lib,
  ...
}: let
  inherit (lib) types mkOption;
  inherit (flake-parts-lib) mkPerSystemOption;
in {
  options = {
    # Custom package definitions at the flake level
    wheels.customPackages = mkOption {
      type = types.attrsOf (types.submodule ({name, ...}: {
        options = {
          # The actual package definition - a function that takes { pkgs, python3Packages } and returns a package
          definition = mkOption {
            type = types.functionTo types.package;
            description = ''
              Function that takes { pkgs, python3Packages } and returns a Python package.
              Example: { pkgs, python3Packages }: python3Packages.buildPythonPackage { ... }
            '';
          };

          # Python versions this package supports
          pythonVersions = mkOption {
            type = types.listOf (types.enum ["39" "310" "311" "312" "313"]);
            default = ["311" "312" "313"];
            description = "Python versions this custom package supports";
          };

          # Whether this package should be available in all Python package sets
          includeInAll = mkOption {
            type = types.bool;
            default = true;
            description = "Whether to include this package in all Python package sets";
          };

          # Description for documentation
          description = mkOption {
            type = types.str;
            default = "Custom Python package: ${name}";
            description = "Description of the custom package";
          };

          # Test configuration for custom packages
          tests = mkOption {
            type = types.submodule {
              options = {
                enabled = mkOption {
                  type = types.bool;
                  default = true;
                  description = "Whether to generate tests for this custom package";
                };

                types = mkOption {
                  type =
                    types.listOf (types.enum ["import" "metadata" "runtime"]);
                  default = ["import" "metadata" "runtime"];
                  description = "Types of tests to generate for this package";
                };

                moduleName = mkOption {
                  type = types.str;
                  default = name;
                  description = "Python module name for import testing (defaults to package name)";
                };

                importTest = mkOption {
                  type = types.nullOr types.str;
                  default = null;
                  description = "Custom import test code (if null, uses default import test)";
                };
              };
            };
            default = {};
            description = "Test configuration for the custom package";
          };
        };
      }));
      default = {};
      description = "Custom Python package definitions";
    };

    # Per-system custom packages (for packages that need system-specific configuration)
    perSystem = mkPerSystemOption ({
      config,
      system,
      pkgs,
      ...
    }: {
      options.wheels.customPackages = mkOption {
        type = types.attrsOf types.package;
        default = {};
        description = "System-specific custom Python packages";
      };
    });
  };
}
