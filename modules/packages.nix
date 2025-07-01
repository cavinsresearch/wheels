# Packages module for flake-parts
{config, ...}: {
  perSystem = {
    config,
    pkgs,
    system,
    self',
    ...
  }: let
    # Apply our overlay to get wheel packages for local use
    # Use the same overlay that the flake exports
    pkgsWithWheels = pkgs.extend config.overlays.default;

    # Import platform-specific packages if they exist
    platformPackages =
      if builtins.pathExists ../${system}.nix
      then
        import ../${system}.nix {
          inherit (pkgsWithWheels.python3Packages) buildPythonPackage;
          inherit (pkgsWithWheels) fetchurl;
          inherit (pkgsWithWheels) python311Packages python312Packages python313Packages;
        }
      else {};
  in {
    packages =
      {
        # Main wheel generator tool
        wheel-generator = pkgs.writeShellScriptBin "wheel-generator" ''
          exec ${pkgs.python3}/bin/python ${../nix_wheel_generator.py} "$@"
        '';

        # Default package points to wheel generator
        default = pkgs.writeShellScriptBin "wheels" ''
          exec ${pkgs.python3}/bin/python ${../nix_wheel_generator.py} "$@"
        '';
      }
      // platformPackages;
  };
}
