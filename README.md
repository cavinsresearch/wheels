# Zeus Python Wheels Flake

This flake provides a complete system for managing pre-compiled Python wheels within a Nix project. It is designed to be modular, extensible, and easy to maintain.

## Features

- **Modular Flake Structure**: Uses `flake-parts` for a clean and organized `flake.nix`.
- **Centralized Package Configuration**: All packages are defined in your `flake.nix`, acting as a single source of truth.
- **Automated Wheel Generation**: Flake apps (`nix run .#generate-wheels`) automatically scrape package indexes like PyPI, download wheels, and generate Nix derivations.
- **Universal & Platform-Specific Wheels**: Correctly handles both pure Python (`py3-none-any`) and platform-specific wheels with compiled extensions.
- **Custom Package Support**: Easily define and manage your own custom Python packages alongside generated ones.
- **Integrated Overlay**: Provides a Nixpkgs overlay to seamlessly inject all managed packages into your Python environments.
- **Built-in Tests**: Automatically generates and runs tests for all managed packages (`nix flake check`).

## Project Structure

The project is organized into logical modules to keep the configuration clean and maintainable.

```
.
├── flake.nix              # Main flake entrypoint and package configuration
├── nix_wheel_generator.py # Core Python script for scraping and generation
├── modules/               # Flake parts modules that contain all the logic
│   ├── apps.nix           # Defines `nix run` commands
│   ├── overlay.nix        # Provides the overlay for downstream projects
│   ├── generators.nix     # Logic for generating Nix code from package specs
│   └── ...                # Other modules for tests, packages, etc.
└── generated/             # Output directory for generated Nix files
    ├── pypi/              # Wheels generated from pypi.org
    │   ├── universal.nix
    │   └── x86_64-linux.nix
    └── nautech/           # Wheels generated from a custom index
        └── ...
```

## Usage

### Using the Overlay in Your Flake

To use the packages provided by this flake, add it as an input to your own project and apply the overlay.

```nix
# your-project/flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    zeus-wheels.url = "github:your-org/zeus-wheels-flake"; # Or path:./path/to/this/flake
  };

  outputs = { self, nixpkgs, zeus-wheels }: {
    # ...
    packages.x86_64-linux = let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        # Apply the overlay here
        overlays = [ zeus-wheels.overlays.default ];
      };
    in {
      # Now you can use any of the managed packages
      devShells.default = pkgs.mkShell {
        packages = [
          (pkgs.python3.withPackages (ps: with ps; [
            # A generated package from PyPI
            databento
            # A generated platform-specific package
            nautilus_trader
            # A custom-defined package
            uuid7
          ]))
        ];
      };
    };
  };
}
```

### Managing Packages

Packages are managed declaratively inside your `flake.nix`. There are two types: generated and custom.

#### 1. Generated Packages

These packages are automatically fetched and packaged by the `nix_wheel_generator.py` script. To add a new one, simply add an entry to the `wheels.packages` attribute set in your `flake.nix`.

```nix
# flake.nix
{
  # ...
  wheels.packages = {
    # Add a new universal package from PyPI
    my_new_package = {
      source = "pypi";
      platforms = ["universal"];
      tests = ["import" "metadata"]; # Optional tests
    };

    # Add a new platform-specific package
    another_package = {
      source = "pypi";
      platforms = ["x86_64-linux" "aarch64-darwin"];
      wheel_name = "another-package-name"; # If wheel name differs
    };
  };
  # ...
}
```

After adding a package, run the generator to create the Nix files:

```bash
nix run .#generate-wheels
```

#### 2. Custom Packages

For packages that are not on a standard index, or require a manual Nix definition, use the `wheels.customPackages` attribute.

**Example: Add `uuid7` as a custom package**

```nix
# flake.nix
{
  # ...
  wheels.customPackages = {
    uuid7 = {
      definition = { pkgs, python3Packages }:
        python3Packages.buildPythonPackage rec {
          pname = "uuid7";
          version = "0.1.0";
          src = python3Packages.fetchPypi {
            inherit pname version;
            sha256 = "sha256-jFeqMu50VtPMaMlcRTC8VxZG3vrAGJXPxzVFRJiUpjw=";
          };
        };
      # Optional: specify which python versions to build for
      pythonVersions = ["311" "312"];
      # Optional: provide a description
      description = "UUID version 7 implementation for Python";
    };
  };
  # ...
}
```

Custom packages are automatically included in the overlay and do not require a generation step.

## Development and Commands

This flake provides several commands for development and maintenance.

### Enter the Development Shell

The development shell provides Python and the `nix-wheel-generator` tool.

```bash
nix develop
```

### Generating Wheels

To generate all wheel derivations from the specifications in `flake.nix`:

```bash
# Generate everything
nix run .#generate-wheels

# Generate for a specific source only
nix run .#generate-pypi
nix run .#generate-nautech
```

The output files will be placed in the `generated/` directory.

### Inspecting Configuration

To see the final configuration that the wheel generator will use, including all package and source definitions:

```bash
nix run .#inspect-config
```

### Running Tests

To run all automated package tests (import checks, ABI compatibility, etc.):

```bash
nix flake check
``` 