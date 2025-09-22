{
  description = "Zeus Python Wheels - Modular Python package management for Nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["aarch64-darwin" "aarch64-linux" "x86_64-linux"];

      imports = [
        ./modules/package-definitions.nix
        ./modules/generators.nix
        ./modules/generated-tests.nix
        ./modules/generated-packages.nix
        ./modules/python-dependencies.nix
        ./modules/apps.nix
        ./modules/devshell.nix
        ./modules/custom-packages.nix
        ./modules/overlay.nix
      ];

      # Source configurations
      wheels.sources = {
        nautech = {
          base_url = "https://packages.nautechsystems.io/simple/";
          default_version_limit = 2;
          use_full_url = false;
        };

        pypi = {
          base_url = "https://pypi.org/simple/";
          default_version_limit = 1;
          use_full_url = true;
        };
      };

      # Package specifications
      wheels.packages = {
        nautilus_trader = {
          source = "nautech";
          platforms = ["aarch64-darwin" "aarch64-linux" "x86_64-linux"];
          tests = ["import" "abi" "runtime" "metadata"];
          wheel_name = "nautilus-trader";
        };

        nautilus_ibapi = {
          source = "pypi";
          platforms = ["universal"];
          tests = ["import" "metadata" "runtime"];
          wheel_name = "nautilus_ibapi";
          module_name = "ibapi";
        };

        databento = {
          source = "pypi";
          platforms = ["universal"];
          tests = ["import" "metadata" "runtime"];
          test_dependencies = ps: with ps; [pandas zstandard pyarrow aiohttp];
        };

        databento_dbn = {
          source = "pypi";
          platforms = ["aarch64-darwin" "aarch64-linux" "x86_64-linux"];
          tests = ["import" "abi" "metadata"];
          wheel_name = "databento-dbn";
        };

        betfair_parser = {
          source = "pypi";
          platforms = ["universal"];
          tests = ["import" "metadata" "runtime"];
          wheel_name = "betfair-parser";
        };

        pandas_gbq = {
          source = "pypi";
          platforms = ["universal"];
          tests = ["import" "metadata" "runtime"];
          wheel_name = "pandas-gbq";
          test_dependencies = ps:
            with ps; [
              google-auth
              google-auth-oauthlib
              google-cloud-bigquery
              packaging
              db-dtypes
            ];
        };

        bybit_history = {
          source = "pypi";
          platforms = ["universal"];
          tests = ["import" "metadata" "runtime"];
          wheel_name = "bybit-history";
        };
      };

      wheels.customPackages = {
        uuid7 = {
          definition = {
            pkgs,
            python3Packages,
          }:
            python3Packages.buildPythonPackage rec {
              pname = "uuid7";
              version = "0.1.0";
              format = "setuptools";
              src = python3Packages.fetchPypi {
                inherit pname version;
                sha256 = "sha256-jFeqMu50VtPMaMlcRTC8VxZG3vrAGJXPxzVFRJiUpjw=";
              };
            };
          pythonVersions = ["311" "312" "313"];
          includeInAll = true;
          description = "UUID version 7 implementation for Python";
          tests = {
            enabled = true;
            types = ["import" "metadata" "runtime"];
            moduleName = "uuid_extensions.uuid7";
          };
        };
      };

      # The overlay is now defined in modules/overlay.nix
    };
}
