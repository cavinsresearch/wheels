{
  self,
  config,
  lib,
  flake-parts-lib,
  ...
}: {
  flake.overlays.default = final: prev: let
    lib = prev.lib;

    # Discover all available sources in the generated directory
    generatedPath = config.wheels.generatedPath;
    availableSources =
      if builtins.pathExists generatedPath
      then builtins.attrNames (builtins.readDir generatedPath)
      else [];

    # Helper function to import platform-specific packages from a source
    importPlatformPackages = sourceName: let
      platformFile = generatedPath + "/${sourceName}/${final.stdenv.hostPlatform.system}.nix";
    in
      if builtins.pathExists platformFile
      then
        import platformFile {
          inherit (final) fetchurl;
          # We'll provide the buildPythonPackage from each specific Python version
          buildPythonPackage = null; # This will be overridden per Python version
          inherit (final) python39Packages python310Packages python311Packages python312Packages python313Packages;
        }
      else {};

    # Helper function to import universal packages from a source
    importUniversalPackages = sourceName: let
      universalFile = generatedPath + "/${sourceName}/universal.nix";
    in
      if builtins.pathExists universalFile
      then import universalFile
      else (python-final: python-prev: {});

    # Helper function to filter packages for nautilus_trader (source-specific logic)
    filterNautilusForPython = pythonVer: packages: let
      versionSpecificName = "nautilus_trader-python${pythonVer}";
    in
      if builtins.hasAttr versionSpecificName packages
      then {nautilus_trader = packages.${versionSpecificName};}
      else {};

    # Helper function to filter version-specific packages (for sources that use -pythonXXX suffix)
    filterVersionSpecificForPython = pythonVer: packages: let
      versionSpecificSuffix = "-python${pythonVer}";
      # Filter packages that end with the version suffix and create proper package names
      versionSpecificPackages = builtins.listToAttrs (
        map (name: {
          name = builtins.replaceStrings [versionSpecificSuffix] [""] name;
          value = packages.${name};
        }) (
          builtins.filter (name: lib.hasSuffix versionSpecificSuffix name)
          (builtins.attrNames packages)
        )
      );
    in
      versionSpecificPackages;

    # Generic platform package filter that handles different source patterns
    filterPlatformForPython = sourceName: pythonVer: packages:
      if sourceName == "nautech"
      then filterNautilusForPython pythonVer packages
      else filterVersionSpecificForPython pythonVer packages;

    # Combine all universal extensions from all sources
    allUniversalExtensions = map importUniversalPackages availableSources;

    # Create combined universal extension
    universalExtension = python-final: python-prev:
      builtins.foldl' (acc: ext: acc // (ext python-final python-prev)) {} allUniversalExtensions;

    # Helper function to create custom packages for a specific Python version
    createCustomPackagesForPython = pythonVer: python-final: python-prev: let
      # Filter custom packages that support this Python version
      supportedCustomPackages =
        lib.filterAttrs (
          name: cfg:
            cfg.includeInAll && builtins.elem pythonVer cfg.pythonVersions
        )
        config.wheels.customPackages;

      # Create packages by calling their definition functions
      customPackages =
        lib.mapAttrs (
          name: cfg:
            cfg.definition {
              pkgs = final;
              python3Packages = python-final;
            }
        )
        supportedCustomPackages;
    in
      customPackages;

    # Helper function to import and filter platform packages for a specific Python version
    importAllPlatformPackagesForPython = pythonVer: python-final: let
      # Import platform packages from all sources
      allPlatformPackages =
        map (sourceName: let
          platformFile = generatedPath + "/${sourceName}/${final.stdenv.hostPlatform.system}.nix";
        in {
          source = sourceName;
          packages =
            if builtins.pathExists platformFile
            then
              import platformFile {
                inherit (python-final) buildPythonPackage;
                inherit (final) fetchurl python39Packages python310Packages python311Packages python312Packages python313Packages;
              }
            else {};
        })
        availableSources;

      # Filter and combine packages from all sources
      filteredPackages =
        map (
          item:
            filterPlatformForPython item.source pythonVer item.packages
        )
        allPlatformPackages;
    in
      builtins.foldl' (acc: pkgs: acc // pkgs) {} filteredPackages;
  in {
    # Add universal wheels to all Python package sets
    pythonPackagesExtensions =
      (prev.pythonPackagesExtensions or [])
      ++ [universalExtension];

    # Override Python interpreters to include packages from all sources and custom packages
    python311 = prev.python311.override {
      packageOverrides = python-final: python-prev:
        (importAllPlatformPackagesForPython "311" python-final)
        // (createCustomPackagesForPython "311" python-final python-prev);
    };

    python312 = prev.python312.override {
      packageOverrides = python-final: python-prev:
        (importAllPlatformPackagesForPython "312" python-final)
        // (createCustomPackagesForPython "312" python-final python-prev);
    };

    python313 = prev.python313.override {
      packageOverrides = python-final: python-prev:
        (importAllPlatformPackagesForPython "313" python-final)
        // (createCustomPackagesForPython "313" python-final python-prev);
    };
  };
}
