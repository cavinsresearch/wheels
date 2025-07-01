# Generator Library Module for Zeus Wheels
# Provides computed values and helper functions from package definitions
{
  config,
  lib,
  ...
}: let
  inherit
    (lib)
    mapAttrs
    mapAttrsToList
    listToAttrs
    filterAttrs
    flatten
    elem
    genAttrs
    concatStringsSep
    attrNames
    ;

  cfg = config.wheels;

  # Helper functions
  getSource = packageName: cfg.sources.${cfg.packages.${packageName}.source};

  getVersionLimit = packageName:
    cfg.packages.${
      packageName
    }.version_limit or (getSource
      packageName).default_version_limit;

  # Generate test matrix for all packages (wheel packages + custom packages)
  generateTestMatrix = let
    # Tests for wheel packages (from sources)
    wheelPackageTests = flatten (mapAttrsToList (packageName: packageSpec:
      flatten (map (testType:
        map (pythonVer: {
          name = "${packageName}-${testType}-python${pythonVer}";
          inherit packageName testType pythonVer;
          spec = packageSpec;
          source = getSource packageName;
        })
        packageSpec.python_versions)
      packageSpec.tests))
    cfg.packages);

    # Tests for custom packages
    customPackageTests = flatten (mapAttrsToList (packageName: customSpec:
      # Only generate tests if enabled
        if customSpec.tests.enabled
        then
          flatten (map (testType:
            map (pythonVer: {
              name = "${packageName}-${testType}-python${pythonVer}";
              inherit packageName testType pythonVer;
              spec = {
                # Convert custom package spec to test spec format
                platforms = ["universal"]; # Custom packages are considered universal
                python_versions = customSpec.pythonVersions;
                tests = customSpec.tests.types;
                module_name = customSpec.tests.moduleName;
                test_dependencies = ps: []; # No additional test dependencies for custom packages
                # Pass through custom import test if specified
                custom_import_test = customSpec.tests.importTest;
              };
              source = "custom"; # Mark as custom source
            })
            customSpec.pythonVersions)
          customSpec.tests.types)
        else [])
    cfg.customPackages);
  in
    wheelPackageTests ++ customPackageTests;

  # Group packages by platform
  generatePackagesByPlatform =
    genAttrs ["aarch64-darwin" "aarch64-linux" "x86_64-linux" "universal"]
    (platform:
      filterAttrs (name: spec: elem platform spec.platforms) cfg.packages);

  # Generate wheel generator commands for each source
  generateWheelCommands = mapAttrs (sourceName: sourceConfig: let
    packagesForSource =
      filterAttrs (name: spec: spec.source == sourceName) cfg.packages;
    packageNames = attrNames packagesForSource;
    wheelNames = map (name: cfg.packages.${name}.wheel_name) packageNames;
  in {
    command = [
      "wheel-generator"
      "--source"
      sourceName
      "--packages"
      (concatStringsSep "," wheelNames)
      "--version-limit"
      (toString sourceConfig.default_version_limit)
    ];
    packages = packagesForSource;
    wheelNames = wheelNames;
  }) cfg.sources;
in {
  config.wheels.generated = {
    testMatrix = generateTestMatrix;
    packagesByPlatform = generatePackagesByPlatform;
    wheelCommands = generateWheelCommands;
  };
}
