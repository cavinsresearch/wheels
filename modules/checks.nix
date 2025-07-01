# Checks module for flake-parts - integrates comprehensive test suite
{...}: {
  perSystem = {
    pkgs,
    system,
    ...
  }: let
    # Import comprehensive test suite
    wheelsTests = import ../tests/default.nix {inherit pkgs system;};
  in {
    # Expose all wheel tests
    checks = wheelsTests.checks;

    # Make debug info available for individual test access
    debug = wheelsTests.debug;
  };
}
