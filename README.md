# Zeus Python Wheels Flake

This flake provides Python wheels and packaging infrastructure for the Zeus project.

## Features

- **Universal wheels** (`py3-none-any`) managed via `pythonPackagesExtensions`
- **Platform-specific wheels** for each supported architecture
- **Automated wheel generation** from PyPI and custom package indexes
- **Integrated overlay** that can be imported into other flakes

## Structure

```
nix/wheels/
├── flake.nix              # Main flake definition
├── universal.nix          # Universal wheels (generated)
├── x86_64-linux.nix      # x86_64 Linux wheels (generated)  
├── aarch64-linux.nix     # ARM64 Linux wheels (generated)
├── aarch64-darwin.nix    # ARM64 macOS wheels (generated)
├── x86_64-darwin.nix     # x86_64 macOS wheels (generated)
└── README.md             # This file
```

## Usage

### As an overlay in another flake

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    zeus-wheels.url = "path:./nix/wheels";
  };

  outputs = { nixpkgs, zeus-wheels, ... }: {
    packages.x86_64-linux = let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [ zeus-wheels.overlays.default ];
      };
    in {
      # Now you have access to all the Python packages
      my-python-env = pkgs.python312.withPackages (ps: with ps; [
        databento       # Universal wheel
        betfair_parser  # Universal wheel  
        nautilus_trader # Platform-specific wheel
      ]);
    };
  };
}
```

### Generating new wheels

```bash
# Enter the development shell
nix develop ./nix/wheels

# Generate wheels from PyPI
nix-wheel-generator --source pypi --packages databento,betfair-parser

# Generate wheels from Nautilus package index
nix-wheel-generator --source nautilus --packages nautilus-trader

# Dry run to see what would be generated
nix-wheel-generator --source pypi --packages some-package --dry-run
```

### Manual wheel management

- **Universal wheels**: Edit `universal.nix` directly or regenerate with the wheel generator
- **Platform-specific wheels**: These are automatically generated per-platform
- **Integration**: The flake automatically detects and imports available wheel files

## Wheel Types

### Universal Wheels (`py3-none-any`)
- Pure Python packages that work across all platforms and Python versions
- Managed via `pythonPackagesExtensions` 
- Available to all Python interpreters automatically
- Examples: `databento`, `betfair-parser`, `pandas-gbq`

### Platform-Specific Wheels  
- Compiled extensions or platform-specific binaries
- Generated per architecture and Python version
- Examples: `nautilus-trader` with native extensions

## Development

The flake provides a development shell with:
- Python 3 with required packages
- The `nix-wheel-generator` tool  
- `alejandra` for formatting generated Nix files

```bash
nix develop ./nix/wheels
``` 