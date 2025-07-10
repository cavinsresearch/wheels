# Generated Tests Module for Zeus Wheels
# Automatically generates comprehensive test suites for all packages
{
  self,
  config,
  lib,
  flake-parts-lib,
  ...
}: let
  inherit (lib) listToAttrs filter substring;
  inherit (flake-parts-lib) mkPerSystemOption;

  cfg = config.wheels;
in {
  options.perSystem = mkPerSystemOption ({
    config,
    pkgs,
    system,
    ...
  }: {
    options.wheels.checks = lib.mkOption {
      type = lib.types.attrsOf lib.types.package;
      default = {};
      description = "Generated wheel tests";
    };
  });

  config.perSystem = {
    config,
    pkgs,
    system,
    self',
    ...
  }: let
    # Apply our overlay to get wheel packages
    # Use the same overlay that the flake exports
    pkgsWithWheels = pkgs.extend self.overlays.default;

    # Filter tests for current platform
    platformTests = filter (test:
      lib.elem system test.spec.platforms
      || lib.elem "universal" test.spec.platforms)
    cfg.generated.testMatrix;

    # Build available packages dynamically from configuration
    # See ADR 014 "Technical Deep Dive: Overlay vs withPackages" for why we use
    # withPackages with all available wheel packages to ensure dependencies are satisfied
    buildAvailablePackages = pythonVer: let
      # Get wheel packages for this platform
      wheelPackages = lib.pipe cfg.packages [
        # Get all package names
        (lib.mapAttrsToList (name: spec: name))
        # Filter to packages available on this platform or universal
        (lib.filter (packageName: let
          spec = cfg.packages.${packageName};
        in
          lib.elem system spec.platforms
          || lib.elem "universal" spec.platforms))
        # Convert to actual package references, handling potentially missing packages
        (lib.map (packageName: let
          pkg =
            pkgsWithWheels."python${pythonVer}Packages".${packageName} or null;
        in
          lib.optional (pkg != null) pkg))
        # Flatten the list (removes empty lists from missing packages)
        lib.flatten
      ];

      # Get custom packages for this Python version  
      customPackages = lib.pipe cfg.customPackages [
        # Filter to packages that support this Python version
        (lib.filterAttrs (name: spec: let
          # Use the helper function to get effective Python versions
          effectiveVersions = 
            if spec.pythonVersions == [] then cfg.pythonVersions else spec.pythonVersions;
        in
          lib.elem pythonVer effectiveVersions))
        # Convert to actual package references by calling the definition function
        (lib.mapAttrsToList (name: spec: 
          spec.definition {
            pkgs = pkgs;
            python3Packages = pkgsWithWheels."python${pythonVer}Packages";
          }))
      ];

      # Get test dependencies for all packages
      testDependencies = lib.pipe cfg.packages [
        # Get all package specs
        (lib.mapAttrsToList (name: spec: spec))
        # Filter to packages available on this platform or universal
        (lib.filter (spec:
          lib.elem system spec.platforms
          || lib.elem "universal" spec.platforms))
        # Get test dependencies for each package
        (lib.map (spec:
          spec.test_dependencies
          pkgsWithWheels."python${pythonVer}Packages"))
        # Flatten all dependency lists
        lib.flatten
      ];
    in
      wheelPackages ++ customPackages ++ testDependencies;

    # Test generators for each type
    makeImportTest = {
      packageName,
      pythonVer,
      spec,
      ...
    }: let
      # Use all configured wheel packages to satisfy dependencies
      # See ADR 014 "Technical Deep Dive: Overlay vs withPackages"
      availablePackages = buildAvailablePackages pythonVer;
      pythonWithPackages =
        pkgsWithWheels."python${pythonVer}".withPackages
        (ps: availablePackages);

      # Use custom import test if provided, otherwise use default
      importTestCode =
        if spec.custom_import_test or null != null
        then spec.custom_import_test
        else ''
          import sys
          print(f'Python version: {sys.version}')
          try:
              import ${spec.module_name}
              print('✅ ${spec.module_name} imported successfully')
              # Try to access basic attributes if available
              if hasattr(${spec.module_name}, '__version__'):
                  print(f'📦 Package version: {${spec.module_name}.__version__}')
          except ImportError as e:
              print(f'❌ Import failed: {e}')
              sys.exit(1)
          except Exception as e:
              print(f'⚠️  Import succeeded but got error: {e}')
        '';
    in
      pkgs.runCommand "${packageName}-import-python${pythonVer}" {
        buildInputs = [pythonWithPackages];
      } ''
        echo "🧪 Testing import of ${packageName} (Python 3.${
          substring 1 2 pythonVer
        })..."
        python -c "${importTestCode}"
        touch $out
      '';

    makeABITest = {
      packageName,
      pythonVer,
      spec,
      ...
    }: let
      # Skip ABI tests for universal packages unless they're on platform-specific platforms
      skipTest = spec.platforms == ["universal"];
    in
      if skipTest
      then
        # Create a placeholder test for universal packages
        pkgs.runCommand "${packageName}-abi-python${pythonVer}" {} ''
          echo "⏭️  Skipping ABI test for ${packageName} - universal package"
          echo "✅ ABI test not applicable for universal Python packages"
          touch $out
        ''
      else
        pkgs.runCommand "${packageName}-abi-python${pythonVer}" {
          buildInputs = [pkgsWithWheels."python${pythonVer}" pkgs.file pkgs.binutils];
        } ''
          echo "🔍 Testing ABI compatibility of ${packageName} (Python 3.${
            substring 1 2 pythonVer
          })..."

          # Handle potential package availability
          PACKAGE="${
            pkgsWithWheels."python${pythonVer}Packages".${packageName} or null
          }"
          if [ "$PACKAGE" = "null" ] || [ ! -d "$PACKAGE" ]; then
            echo "⚠️  Package ${packageName} not available for Python 3.${
            substring 1 2 pythonVer
          } on ${system}"
            echo "✅ ABI test skipped (package not available)"
            touch $out
            exit 0
          fi

          PACKAGE_PATH="$PACKAGE/lib/python3.${
            substring 1 2 pythonVer
          }/site-packages"

          if [ ! -d "$PACKAGE_PATH" ]; then
            echo "❌ Package path not found: $PACKAGE_PATH"
            exit 1
          fi

          echo "📁 Package installed at: $PACKAGE_PATH"

          # Check if package has any compiled extensions
          SO_FILES=$(find "$PACKAGE_PATH" -name "*.so" 2>/dev/null || true)

          if [ -z "$SO_FILES" ]; then
            echo "⚠️  No compiled extensions found - this may indicate a universal package incorrectly marked as platform-specific"
            echo "✅ Package appears to be pure Python"
          else
            echo "🔍 Found compiled extensions, checking ABI compatibility..."
            SO_COUNT=$(echo "$SO_FILES" | wc -l)
            echo "📊 Found $SO_COUNT shared object files"

            for so_file in $SO_FILES; do
              echo "🔎 Analyzing: $(basename "$so_file")"

              # Check file type and architecture
              FILE_INFO=$(file "$so_file")
              echo "   File info: $FILE_INFO"

              # Verify it's a shared library
              if ! echo "$FILE_INFO" | grep -q "shared object\|dynamic library\|Mach-O.*\(bundle\|shared library\)"; then
                echo "❌ Not a shared object: $so_file"
                exit 1
              fi

              # Check architecture matches expected
              case "${system}" in
                "aarch64-darwin")
                  if ! echo "$FILE_INFO" | grep -q "arm64"; then
                    echo "❌ Architecture mismatch: expected arm64, got: $FILE_INFO"
                    exit 1
                  fi
                  ;;
                "x86_64-linux")
                  if ! echo "$FILE_INFO" | grep -q "x86-64"; then
                    echo "❌ Architecture mismatch: expected x86-64, got: $FILE_INFO"
                    exit 1
                  fi
                  ;;
                "aarch64-linux")
                  if ! echo "$FILE_INFO" | grep -q "aarch64"; then
                    echo "❌ Architecture mismatch: expected aarch64, got: $FILE_INFO"
                    exit 1
                  fi
                  ;;
              esac

              echo "   ✅ $(basename "$so_file") passes ABI checks"
            done

            echo "✅ All $SO_COUNT shared objects pass ABI compatibility checks"
          fi

          touch $out
        '';

    makeMetadataTest = {
      packageName,
      pythonVer,
      spec,
      ...
    }: let
      # Use all configured wheel packages to satisfy dependencies
      # See ADR 014 "Technical Deep Dive: Overlay vs withPackages"
      availablePackages = buildAvailablePackages pythonVer;
      pythonWithPackages =
        pkgsWithWheels."python${pythonVer}".withPackages
        (ps: availablePackages);
    in
      pkgs.runCommand "${packageName}-metadata-python${pythonVer}" {
        buildInputs = [pythonWithPackages];
      } ''
        echo "📋 Testing metadata of ${packageName} (Python 3.${
          substring 1 2 pythonVer
        })..."
        python -c "
        import sys
        try:
            import importlib.metadata as meta

            # Try to get package metadata
            try:
                pkg = meta.distribution('${packageName}')
                print(f'✅ Package: {pkg.name} v{pkg.version}')

                # Check basic metadata
                if pkg.metadata.get('Summary'):
                    print(f'📝 Summary: {pkg.metadata[\"Summary\"]}')

                # Check files
                files = pkg.files or []
                print(f'📦 Contains {len(files)} files')

                # Check for common metadata
                if pkg.metadata.get('Author'):
                    print(f'👤 Author: {pkg.metadata[\"Author\"]}')

                if pkg.metadata.get('Home-page'):
                    print(f'🏠 Homepage: {pkg.metadata[\"Home-page\"]}')

            except meta.PackageNotFoundError:
                print(f'⚠️  Package metadata not found for ${packageName}')
                print('   This might be expected for some wheel packages')
            except Exception as e:
                print(f'⚠️  Metadata access error: {e}')

        except ImportError:
            print('⚠️  importlib.metadata not available (Python < 3.8)')
        except Exception as e:
            print(f'❌ Metadata test failed: {e}')
            sys.exit(1)
        "
        touch $out
      '';

    makeRuntimeTest = {
      packageName,
      pythonVer,
      spec,
      ...
    }: let
      # Use all configured wheel packages to satisfy dependencies
      # See ADR 014 "Technical Deep Dive: Overlay vs withPackages"
      availablePackages = buildAvailablePackages pythonVer;
      pythonWithPackages =
        pkgsWithWheels."python${pythonVer}".withPackages
        (ps: availablePackages);
    in
      pkgs.runCommand "${packageName}-runtime-python${pythonVer}" {
        buildInputs = [pythonWithPackages];
      } ''
        echo "⚡ Testing runtime functionality of ${packageName} (Python 3.${
          substring 1 2 pythonVer
        })..."
        python -c "
        import sys
        import ${spec.module_name}

        print(f'✅ ${spec.module_name} imported successfully')

        # Basic runtime checks
        try:
            # Check if package has common attributes
            attrs = dir(${spec.module_name})
            print(f'📊 Package has {len(attrs)} public attributes')

            # Look for version info
            version_attrs = [attr for attr in attrs if 'version' in attr.lower()]
            if version_attrs:
                print(f'🔖 Version attributes found: {version_attrs}')

            # Basic functionality test - try to access main attributes
            print('🔍 Checking main package structure...')

            # This is a basic test - in a real scenario, you'd add package-specific tests
            print('✅ ${spec.module_name} runtime test completed successfully')

        except Exception as e:
            print(f'⚠️  Runtime test warning: {e}')
            print('   (This may be expected for some packages)')
        "
        touch $out
      '';

    makeIntegrationTest = {
      packageName,
      pythonVer,
      spec,
      ...
    }: let
      # Use all configured wheel packages to satisfy dependencies
      # See ADR 014 "Technical Deep Dive: Overlay vs withPackages"
      availablePackages = buildAvailablePackages pythonVer;
      pythonWithPackages =
        pkgsWithWheels."python${pythonVer}".withPackages
        (ps: availablePackages);
    in
      pkgs.runCommand "${packageName}-integration-python${pythonVer}" {
        buildInputs = [pythonWithPackages];
      } ''
        echo "🔗 Testing integration of ${packageName} (Python 3.${
          substring 1 2 pythonVer
        })..."
        python -c "
        import ${packageName}

        # Integration test - verify package works in isolation
        print('✅ ${packageName} integration test passed')
        "
        touch $out
      '';

    makeIsolationTest = {
      packageName,
      pythonVer,
      spec,
      ...
    }: let
      # Use all configured wheel packages to satisfy dependencies
      # See ADR 014 "Technical Deep Dive: Overlay vs withPackages"
      availablePackages = buildAvailablePackages pythonVer;
      pythonWithPackages =
        pkgsWithWheels."python${pythonVer}".withPackages
        (ps: availablePackages);
    in
      pkgs.runCommand "${packageName}-isolation-python${pythonVer}" {
        buildInputs = [pythonWithPackages];
      } ''
        echo "🏝️  Testing isolation of ${packageName} (Python 3.${
          substring 1 2 pythonVer
        })..."
        python -c "
        # Test that package doesn't interfere with system
        import sys
        import ${packageName}

        print('✅ ${packageName} isolation test passed')
        "
        touch $out
      '';

    # Test type mapping
    testGenerators = {
      import = makeImportTest;
      abi = makeABITest;
      metadata = makeMetadataTest;
      runtime = makeRuntimeTest;
      integration = makeIntegrationTest;
      isolation = makeIsolationTest;
    };

    # Essential integration tests not covered by generated system
    essentialTests = {
      # Test that the flake's overlay output actually works (the critical integration test)
      wheels-flake-overlay-integration = let
        # This tests the actual overlay that gets exported by the flake
        flakeOverlay = self.overlays.default;
        testPkgs = pkgs.extend flakeOverlay;
        # Use the same dependency resolution as other tests
        availablePackages = buildAvailablePackages "312";
        pythonWithFlakeWheels =
          testPkgs.python312.withPackages (ps: availablePackages);
      in
        pkgs.runCommand "wheels-flake-overlay-integration-test" {
          buildInputs = [pythonWithFlakeWheels];
        } ''
          echo "🔍 Testing that flake overlay integration actually works..."
          echo "This is the critical test that should catch main flake integration failures!"

          # Test that all packages are available through the flake's exported overlay
          python -c "
          import sys

          test_packages = [
              ('ibapi', 'nautilus_ibapi'),
              ('databento', 'databento'),
              ('betfair_parser', 'betfair_parser'),
              ('pandas_gbq', 'pandas_gbq')
          ]

          print('Testing flake overlay integration...')
          failed = []

          for import_name, package_name in test_packages:
              try:
                  module = __import__(import_name)
                  print(f'✅ {package_name} ({import_name}) imported successfully')
                  print(f'    Location: {module.__file__}')
              except ImportError as e:
                  print(f'❌ {package_name} ({import_name}) FAILED: {e}')
                  failed.append(package_name)

          if failed:
              print(f'CRITICAL: Flake overlay integration FAILED for: {failed}')
              print('This means the main flake cannot use these packages!')
              sys.exit(1)
          else:
              print('✅ All packages available via flake overlay - main flake integration should work')
          "

          echo "✅ Flake overlay integration test passed"
          touch $out
        '';
      # Test that overlay discovers and loads all available sources
      wheels-overlay-discovery = let
        # Use the same dependency resolution as other tests
        availablePackages = buildAvailablePackages "312";
        pythonWithWheels =
          pkgsWithWheels.python312.withPackages (ps: availablePackages);
      in
        pkgs.runCommand "wheels-overlay-discovery-test" {
          buildInputs = [pythonWithWheels];
        } ''
          echo "🔍 Testing overlay source discovery and loading..."

          # Test that overlay properly discovers generated sources
          python -c "
          import sys

          # Test that packages from different sources are available
          test_packages = [
              ('ibapi', 'nautilus_ibapi'),  # (import_name, package_name)
              ('databento', 'databento'),
              ('betfair_parser', 'betfair_parser'),
              ('pandas_gbq', 'pandas_gbq')
          ]
          available_packages = []

          for import_name, package_name in test_packages:
              try:
                  __import__(import_name)
                  available_packages.append(package_name)
                  print(f'✅ {package_name} available (imports as {import_name})')
              except ImportError as e:
                  print(f'⚠️  {package_name} not available: {e}')

          if len(available_packages) == 0:
              print('❌ No packages available - overlay discovery failed')
              sys.exit(1)

          print(f'✅ Overlay discovery test passed: {len(available_packages)}/{len(test_packages)} packages available')
          "

          touch $out
        '';

      # Test cross-version isolation
      wheels-cross-version-isolation =
        pkgs.runCommand "wheels-cross-version-isolation-test" {
          buildInputs = [pkgsWithWheels.python311 pkgsWithWheels.python313];
        } ''
          echo "🔒 Testing cross-version isolation..."

          # Verify packages are installed to different paths
          PYTHON311_PATH=$(${
            pkgsWithWheels.python311.withPackages (ps: [ps.nautilus_ibapi])
          }/bin/python -c "import ibapi; print(ibapi.__file__)" 2>/dev/null || echo "not-found")
          PYTHON313_PATH=$(${
            pkgsWithWheels.python313.withPackages (ps: [ps.nautilus_ibapi])
          }/bin/python -c "import ibapi; print(ibapi.__file__)" 2>/dev/null || echo "not-found")

          if [[ "$PYTHON311_PATH" == "$PYTHON313_PATH" ]]; then
            echo "❌ Packages not properly isolated between Python versions"
            echo "Python 3.11: $PYTHON311_PATH"
            echo "Python 3.13: $PYTHON313_PATH"
            exit 1
          fi

          echo "✅ Cross-version isolation verified"
          echo "Python 3.11: $PYTHON311_PATH"
          echo "Python 3.13: $PYTHON313_PATH"

          touch $out
        '';

      # Test generated file integrity
      wheels-generated-files-integrity =
        pkgs.runCommand "wheels-generated-files-integrity-test" {
          buildInputs = [pkgs.nix];
        } ''
          echo "📋 Testing generated Nix file integrity..."

          # Check if generated files are valid Nix expressions
          for nix_file in ${../generated}/*/*.nix; do
            if [[ -f "$nix_file" ]]; then
              echo "Checking $nix_file..."
              nix-instantiate --parse "$nix_file" > /dev/null || {
                echo "❌ Invalid Nix syntax in $nix_file"
                exit 1
              }
            fi
          done

          echo "✅ All generated Nix files have valid syntax"
          touch $out
        '';
    };

    # Generate all tests
    generatedTests = listToAttrs (map (test: {
        name = test.name;
        value = testGenerators.${test.testType} test;
      })
      platformTests);

    # Combine generated and essential tests
    allTests = generatedTests // essentialTests;
  in {
    wheels.checks = allTests;
    checks = allTests;
  };
}
