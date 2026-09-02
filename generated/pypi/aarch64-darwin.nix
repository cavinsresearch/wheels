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
    version = "0.69.0";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/06/6d/863d23f68c72a83261b283e31acb26c69dadb203d62b3387389738b37a9b/databento_dbn-0.69.0-cp310-cp310-macosx_10_12_x86_64.macosx_11_0_arm64.macosx_10_12_universal2.whl";
      sha256 = "sha256-Q9ebrTVcA9ZdmUrurTenh679thUN+2lelNz/qwATukQ=";
    };

    format = "wheel";
  };

  "databento_dbn-python311" = python311Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.69.0";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/b0/c9/a3211fa9adfda06086b9bc31ae20ed0f9ad0c20b9bbab74fc87bb0aacea2/databento_dbn-0.69.0-cp311-cp311-macosx_10_12_x86_64.macosx_11_0_arm64.macosx_10_12_universal2.whl";
      sha256 = "sha256-HUoO3lLqfZ3OsiRWdIDkWn24Y9sppPdZOGfYdLJUzag=";
    };

    format = "wheel";
  };

  "databento_dbn-python312" = python312Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.69.0";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/8c/c2/449fcdff998d003c229c3a73b37ed4a1ead514e5588ad4f227f7d1e8f3c9/databento_dbn-0.69.0-cp312-cp312-macosx_10_12_x86_64.macosx_11_0_arm64.macosx_10_12_universal2.whl";
      sha256 = "sha256-LmzTH5Mx45TFosPfR50aCgj43j98VTMrYNvNzFMBLvk=";
    };

    format = "wheel";
  };

  "databento_dbn-python313" = python313Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.69.0";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/c8/57/b0e6b0f5fe2c4d56ecfc5dce8001d49bbf3cd4015fc4aec28669ee99698e/databento_dbn-0.69.0-cp313-cp313-macosx_10_12_x86_64.macosx_11_0_arm64.macosx_10_12_universal2.whl";
      sha256 = "sha256-BS6kmvnBqz+hsjI/JifsCHYzVX6D16LNnspco4mf41Q=";
    };

    format = "wheel";
  };

  "databento_dbn-python314" = python314Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.69.0";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/4b/95/4635d2e019d5102df2b584e95ec688fd16583b7eb5f9071da4e71e5b8ac0/databento_dbn-0.69.0-cp314-cp314-macosx_10_12_x86_64.macosx_11_0_arm64.macosx_10_12_universal2.whl";
      sha256 = "sha256-Akq0pTbaC9+K2dmknvJO3StzLjNBinEIL9g7aPclrlw=";
    };

    format = "wheel";
  };
}
