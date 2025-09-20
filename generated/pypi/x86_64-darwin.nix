{
  buildPythonPackage,
  fetchurl,
  python39Packages,
  python310Packages,
  python311Packages,
  python312Packages,
  python313Packages,
  ...
}: {
  "databento_dbn-python310" = python310Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.41.0";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/65/01/6e78217f911338549d0421ca700a942bd90c34cf0f57f608ab2abb9765f9/databento_dbn-0.41.0-cp310-cp310-macosx_10_12_x86_64.macosx_11_0_arm64.macosx_10_12_universal2.whl";
      sha256 = "sha256-pwbTDSKtzRk+lpyNqElol4qIRxy0dL+EwQDcw3FUTmI=";
    };

    format = "wheel";
  };

  "databento_dbn-python311" = python311Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.41.0";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/cd/b7/8910779636fbf9ea2d774a3cd6ac4ae38883b6a0af8fcd70cdbd7de0d565/databento_dbn-0.41.0-cp311-cp311-macosx_10_12_x86_64.macosx_11_0_arm64.macosx_10_12_universal2.whl";
      sha256 = "sha256-+RBRGK2x60I69lRshlX7jv6PYsZnK1ZkN91Hcnxkqxw=";
    };

    format = "wheel";
  };

  "databento_dbn-python312" = python312Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.41.0";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/30/c2/fcf550210931fd5fd841275b3efceb91b0b6e5307850bf44fdbcf86d31e6/databento_dbn-0.41.0-cp312-cp312-macosx_10_12_x86_64.macosx_11_0_arm64.macosx_10_12_universal2.whl";
      sha256 = "sha256-J3oZUrUZqVbV15c/qAk8FohECyCyJE2ntwKhEyC/UTQ=";
    };

    format = "wheel";
  };

  "databento_dbn-python313" = python313Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.41.0";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/06/2c/bdf07d2b66c02aa11c0a7422b05a439beddc40e73f944a8e5efd37d33aff/databento_dbn-0.41.0-cp313-cp313-macosx_10_12_x86_64.macosx_11_0_arm64.macosx_10_12_universal2.whl";
      sha256 = "sha256-79BxL/fUQ0EfDdZuy/jWE9xcD7cOc6Sq6lfQyqfZ5cg=";
    };

    format = "wheel";
  };

  "databento_dbn-python39" = python39Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.41.0";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/07/1a/5330cede9f53e57e82ebe91dd05f6c6fce8506fc250242b6d2cc0864f61b/databento_dbn-0.41.0-cp39-cp39-macosx_10_12_x86_64.macosx_11_0_arm64.macosx_10_12_universal2.whl";
      sha256 = "sha256-JTVRY8m+ZNcCPcBQXqVKejmnq9fKe0PlAYgXPZjkSeI=";
    };

    format = "wheel";
  };
}
