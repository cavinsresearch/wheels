# Development shell module for flake-parts
{...}: {
  perSystem = {pkgs, ...}: {
    devShells.default = pkgs.mkShell {
      name = "wheels-dev";

      buildInputs = with pkgs; [
        # Python with essential packages for wheel management
        python3
        python3Packages.requests
        python3Packages.packaging
        python3Packages.pip
        python3Packages.wheel
        python3Packages.setuptools

        # Development and testing tools
        python3Packages.pytest
        python3Packages.black
        python3Packages.isort
        python3Packages.mypy

        # Nix tools
        nix
        nixpkgs-fmt
        alejandra

        # Shell utilities
        jq
        curl
        wget
        file

        # For testing binary compatibility
        binutils

        # Git for version control
        git
      ];

      shellHook = ''
        echo "🎡 Zeus Python Wheels Development Environment"
        echo "============================================="
        echo ""
        echo "Available commands:"
        echo "  wheel-generator    - Generate Nix expressions for Python wheels"
        echo "  python             - Python interpreter with wheel tools"
        echo "  pytest             - Run tests"
        echo "  nix flake check    - Run all checks"
        echo "  nix build          - Build wheel packages"
        echo ""
        echo "Example usage:"
        echo "  ./wheel-generator --source pypi --packages databento-dbn --dry-run"
        echo "  nix build .#nautilus_ibapi311"
        echo "  nix flake check"
        echo ""

        # Make wheel generator available in PATH
        export PATH="${pkgs.python3}/bin:$PATH"

        # Set up aliases for convenience
        alias wg='python ${../nix_wheel_generator.py}'
        alias wheel-gen='python ${../nix_wheel_generator.py}'
        alias test-wheels='nix flake check'
        alias build-wheels='nix build'

        echo "🚀 Ready to work with Python wheels!"
      '';
    };
  };
}
