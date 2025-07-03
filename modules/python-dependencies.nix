# Python Dependencies Module for Zeus Wheels
# Provides shared Python package dependencies for wheel generation and development
{
  config,
  lib,
  flake-parts-lib,
  ...
}: let
  inherit (flake-parts-lib) mkPerSystemOption;
in {
  options.perSystem = mkPerSystemOption ({
    config,
    pkgs,
    system,
    ...
  }: {
    options.wheels.python = {
      wheelGeneratorEnv = lib.mkOption {
        type = lib.types.package;
        description = "Python environment with wheel generator dependencies";
      };

      devDependencies = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        description = "List of Python packages needed for development";
      };

      generatorDependencies = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        description = "List of Python packages needed for wheel generation";
      };
    };
  });

  config.perSystem = {
    config,
    pkgs,
    system,
    ...
  }: let
    # Core Python packages needed for wheel generation
    generatorDependencies = with pkgs.python3Packages; [
      requests
      beautifulsoup4
      jinja2
      packaging
      pip
      wheel
      setuptools
    ];

    # Additional development tools
    devToolDependencies = with pkgs.python3Packages; [
      pytest
      black
      isort
      mypy
    ];

    # Create a Python environment with all generator dependencies
    wheelGeneratorEnv = pkgs.python3.withPackages (ps: generatorDependencies);

  in {
    wheels.python = {
      inherit wheelGeneratorEnv;
      generatorDependencies = generatorDependencies;
      devDependencies = generatorDependencies ++ devToolDependencies;
    };
  };
} 