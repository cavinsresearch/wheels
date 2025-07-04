# Development shell module for flake-parts
{...}: {
  perSystem = {pkgs, config, ...}: {
    devShells.default = pkgs.mkShell {
      name = "wheels-dev";

      buildInputs = with pkgs; [
        # Python with wheel generation and development packages
        config.wheels.python.wheelGeneratorEnv

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
        export PATH="${config.wheels.python.wheelGeneratorEnv}/bin:$PATH"

        # Set up aliases for convenience
        alias wg='${config.wheels.python.wheelGeneratorEnv}/bin/python ${../nix_wheel_generator.py}'
        alias wheel-gen='${config.wheels.python.wheelGeneratorEnv}/bin/python ${../nix_wheel_generator.py}'
        alias test-wheels='nix flake check'
        alias build-wheels='nix build'

        echo "🚀 Ready to work with Python wheels!"
      '';
    };
  };
}
