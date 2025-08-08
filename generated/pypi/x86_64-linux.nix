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
    version = "0.39.0";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/56/7c/dcdcbef4eb7f8406aebee231992e95632319b3ecefd9d665fe22b7d3ede3/databento_dbn-0.39.0-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl";
      sha256 = "sha256-fX2TtvcaLWrVfbzhLKIM+O3/DiUXpdVcjqgAfQ1Dlvg=";
    };

    format = "wheel";
  };

  "databento_dbn-python311" = python311Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.39.0";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/5d/6b/1c63f281f31a2b9b169d68c2f90c2118654166c3890f4eebf72869491349/databento_dbn-0.39.0-cp311-cp311-manylinux_2_17_x86_64.manylinux2014_x86_64.whl";
      sha256 = "sha256-aYH3befSS0iX/9YDUAz5PqffD9BBS27y7gfGK8h6RxA=";
    };

    format = "wheel";
  };

  "databento_dbn-python312" = python312Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.39.0";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/0e/67/c8a33564978767430edb48ad984263b08e3a0ba26257cc92086c3de9ea7b/databento_dbn-0.39.0-cp312-cp312-manylinux_2_17_x86_64.manylinux2014_x86_64.whl";
      sha256 = "sha256-I6r07YYht/Jur9bwRq5k5dTCHJznQdXiAULKcbHjRS8=";
    };

    format = "wheel";
  };

  "databento_dbn-python313" = python313Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.39.0";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/d0/9f/039272b93eb9213cf8a618b2bf238925f1b1e670b6f0e329a60ba1101acc/databento_dbn-0.39.0-cp313-cp313-manylinux_2_17_x86_64.manylinux2014_x86_64.whl";
      sha256 = "sha256-BvhuN0vq1nxrgcRG8L5NCkZAzMHoQBY6+MDY9GBFGeU=";
    };

    format = "wheel";
  };

  "databento_dbn-python39" = python39Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.39.0";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/0a/74/b3f5dc6629fbfb242b8dc4b9ac0b3a818ada8f1d660ab3439b5d73a6b31d/databento_dbn-0.39.0-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl";
      sha256 = "sha256-avD6HAhC5ONpKCy0RpJbe1GUjCH075maff5m0MF9qoM=";
    };

    format = "wheel";
  };
}
