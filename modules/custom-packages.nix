# Custom Packages Module for Zeus Wheels
# Allows definition of custom Python packages alongside generated wheel packages
{
  config,
  lib,
  ...
}: let
  inherit (lib) types mkOption;
  cfg = config.wheels;
in {
  options.wheels.customPackages = mkOption {
    type = types.attrsOf (types.submodule ({name, ...}: {
      options = {
        definition = mkOption {
          type = types.functionTo types.package;
          description = "Function that takes {pkgs, python3Packages} and returns a package derivation";
        };

        pythonVersions = mkOption {
          type = types.listOf (types.enum ["39" "310" "311" "312" "313" "314"]);
          default = [];
          description = "Python versions to build this package for (if empty, uses global pythonVersions)";
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
                type = types.listOf (types.enum ["import" "metadata" "runtime"]);
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
} 