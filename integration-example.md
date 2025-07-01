# Zeus Python Wheels Integration Guide

This document provides integration examples for using the Zeus Python Wheels system.

## Basic Flake Integration

### Minimal Example

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    zeus-wheels.url = "path:../zeus/nix/wheels";
  };

  outputs = { nixpkgs, zeus-wheels, ... }: {
    # Use the overlay to add packages
    nixosConfigurations.example = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        {
          nixpkgs.overlays = [ zeus-wheels.overlays.default ];
          environment.systemPackages = with pkgs; [
            (python311.withPackages (ps: with ps; [
              nautilus_trader
              databento
              uuid7  # Custom package!
            ]))
          ];
        }
      ];
    };
  };
}
```

## Custom Python Packages

You can define custom Python packages that will be automatically included in all Python package sets:

### Example: Adding Custom Packages

```nix
{
  description = "My project with custom Python packages";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["aarch64-darwin" "aarch64-linux" "x86_64-linux"];

      imports = [
        ./nix/wheels/modules/custom-packages.nix
        # ... other modules
      ];

      # Define custom Python packages (can be imported from a separate file)
      wheels.customPackages = import ./custom-packages-config.nix;
      
      # Or define inline:
      # wheels.customPackages = {
      #   # Example 1: Simple PyPI package
      #   uuid7 = {
      #     definition = {pkgs, python3Packages}: python3Packages.buildPythonPackage rec {
      #       pname = "uuid7";
      #       version = "0.1.0";
      #       src = python3Packages.fetchPypi {
      #         inherit pname version;
      #         sha256 = "sha256-jFeqMu50VtPMaMlcRTC8VxZG3vrAGJXPxzVFRJiUpjw=";
      #       };
      #     };
      #     pythonVersions = ["311" "312" "313"];
      #     description = "UUID version 7 implementation for Python";
      #   };

        # Example 2: Package from Git
        my-custom-lib = {
          definition = {pkgs, python3Packages}: python3Packages.buildPythonPackage {
            pname = "my-custom-lib";
            version = "1.0.0";
            src = pkgs.fetchFromGitHub {
              owner = "myorg";
              repo = "my-custom-lib";
              rev = "v1.0.0";
              sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
            };
            propagatedBuildInputs = with python3Packages; [ requests ];
          };
          pythonVersions = ["311" "312" "313"];
          description = "My custom Python library";
        };

        # Example 3: Package with complex dependencies
        ml-toolkit = {
          definition = {pkgs, python3Packages}: python3Packages.buildPythonPackage {
            pname = "ml-toolkit";
            version = "2.1.0";
            src = python3Packages.fetchPypi {
              inherit pname version;
              sha256 = "sha256-BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB=";
            };
            propagatedBuildInputs = with python3Packages; [ 
              numpy 
              pandas 
              scikit-learn 
            ];
            # Override specific Python versions if needed
            pythonVersions = ["312" "313"];  # Only for newer Python
            checkPhase = ''
              python -m pytest tests/
            '';
          };
          description = "Machine learning toolkit with advanced features";
        };
      };

      # The rest of your flake configuration...
      flake = {
        overlays.default = import ./overlay.nix;
      };
    };
}
```

### Configuration File Approach (Recommended)

For better organization, you can define custom packages in a separate file:

**custom-packages-config.nix:**
```nix
{
  uuid7 = {
    definition = {pkgs, python3Packages}: python3Packages.buildPythonPackage rec {
      pname = "uuid7";
      version = "0.1.0";
      src = python3Packages.fetchPypi {
        inherit pname version;
        sha256 = "sha256-jFeqMu50VtPMaMlcRTC8VxZG3vrAGJXPxzVFRJiUpjw=";
      };
    };
    pythonVersions = ["311" "312" "313"];
    includeInAll = true;
    description = "UUID version 7 implementation for Python";
  };
  
  # Add more packages here...
}
```

**flake.nix:**
```nix
wheels.customPackages = import ./custom-packages-config.nix;
```

This approach provides:
- **Better organization** for multiple custom packages
- **Easier maintenance** and updates
- **Cleaner flake.nix** files
- **Reusability** across different flakes

### Custom Package Options

Each custom package supports the following options:

- **`definition`** (required): Function that takes `{pkgs, python3Packages}` and returns a package
- **`pythonVersions`** (default: `["311" "312" "313"]`): List of Python versions to support
- **`includeInAll`** (default: `true`): Whether to include in all Python package sets
- **`description`** (default: auto-generated): Description for documentation

### Using Custom Packages

Once defined, custom packages are automatically available in all Python environments:

```bash
# In a development shell
nix develop
python -c "import uuid7; print(uuid7.uuid7())"

# Or in a Python environment
nix shell nixpkgs#python311.withPackages(ps: [ps.uuid7])
python -c "import uuid7"
```

## System-Specific Custom Packages

For packages that need system-specific configuration, you can use `perSystem`:

```nix
perSystem = {system, pkgs, ...}: {
  wheels.customPackages = {
    # This package is available only on this specific system
    system-specific-tool = pkgs.python3Packages.buildPythonPackage {
      # ... package definition
    };
  };
};
```

## Generated vs Custom Packages

- **Generated packages** (via `wheels.packages`): Automatically downloaded from PyPI/custom indexes
- **Custom packages** (via `wheels.customPackages`): Manually defined Nix expressions

Both types are automatically included in the overlay and available in Python environments.

## Best Practices

1. **Version Pinning**: Always specify exact versions in custom packages
2. **Hash Verification**: Include proper SHA256 hashes for security
3. **Dependencies**: Declare all Python dependencies in `propagatedBuildInputs`
4. **Testing**: Include basic import tests for custom packages
5. **Documentation**: Provide clear descriptions for custom packages

## Troubleshooting

### Package Not Available
- Check that the package name matches the attribute name
- Verify Python version compatibility
- Ensure `includeInAll = true` (default)

### Build Failures
- Check dependencies are correctly specified
- Verify source URLs and hashes
- Test the package definition in isolation

### Import Errors
- Ensure all runtime dependencies are included
- Check Python version compatibility
- Verify the package builds correctly 