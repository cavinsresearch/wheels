# Zeus Wheels Workflow

## Overview

The Zeus project now uses a separate flake for managing Python wheels, making the packaging more modular and maintainable.

## Quick Start

### 1. Generate new wheels
```bash
# From the project root
python3 nix/wheels/nix_wheel_generator.py --source pypi --packages databento,betfair-parser

# This will create/update files in nix/wheels/:
# - universal.nix (for py3-none-any wheels)
# - {platform}.nix files (for platform-specific wheels)
```

### 2. Test the wheels flake
```bash
nix flake check ./nix/wheels
```

### 3. Use in the main project
```bash
# After integrating with main flake.nix
nix develop
python3 -c "import databento; print('Success!')"
```

## File Structure

```
nix/wheels/
├── flake.nix              # Main flake with overlay
├── universal.nix          # Universal wheels (py3-none-any)
├── x86_64-linux.nix      # Platform-specific wheels
├── aarch64-linux.nix     # Platform-specific wheels  
├── aarch64-darwin.nix    # Platform-specific wheels
├── x86_64-darwin.nix     # Platform-specific wheels
├── README.md             # Documentation
├── WORKFLOW.md           # This file
└── integration-example.md # Integration guide
```

## Wheel Types

### Universal Wheels
- **File**: `universal.nix`
- **Format**: `pythonPackagesExtensions` function
- **When**: Package has `py3-none-any` wheels
- **Examples**: `databento`, `betfair-parser`, `pandas-gbq`

### Platform-Specific Wheels  
- **Files**: `{platform}.nix` (e.g., `x86_64-linux.nix`)
- **Format**: Attribute set with versioned packages
- **When**: Package has compiled extensions or platform binaries
- **Examples**: `nautilus-trader` with native code

## Workflow Commands

### Generate wheels from PyPI
```bash
python3 nix/wheels/nix_wheel_generator.py \
  --source pypi \
  --packages package1,package2 \
  --verbose
```

### Generate wheels from Nautilus index
```bash
python3 nix/wheels/nix_wheel_generator.py \
  --source nautilus \
  --packages nautilus-trader \
  --version-limit 2
```

### Preview what would be generated (dry run)
```bash
python3 nix/wheels/nix_wheel_generator.py \
  --source pypi \
  --packages some-package \
  --dry-run
```

### Test wheels flake
```bash
nix flake check ./nix/wheels
nix flake show ./nix/wheels
```

### Enter development environment
```bash
nix develop ./nix/wheels
```

## Integration with Main Project

See `integration-example.md` for detailed steps to integrate the wheels flake into your main project.

### Key changes needed:
1. Add `zeus-wheels.url = "path:./nix/wheels";` to inputs
2. Replace `self.overlays.nautilus` with `inputs.zeus-wheels.overlays.default`
3. Remove `./nix/nautilus` from imports

## Benefits

### Modularity
- Wheels are isolated from main project logic
- Can be developed and tested independently
- Clear separation of concerns

### Efficiency
- Universal wheels generate only 1 derivation instead of 16+
- Platform-specific wheels only for packages that need them
- Faster builds and smaller closures

### Maintainability
- Automated wheel generation
- Consistent overlay structure
- Easy to add new packages

## Troubleshooting

### "Package not found" error
- Check if package exists on the source index
- Try with `--verbose` flag for more details
- Verify package name spelling

### "No wheels found" warning
- Package might only have source distributions
- Try a different source (pypi vs nautilus)
- Check if wheels are available for your platform

### Flake evaluation errors
- Run `nix flake check ./nix/wheels` for detailed errors
- Check syntax with `alejandra nix/wheels/*.nix`
- Verify all referenced files exist 