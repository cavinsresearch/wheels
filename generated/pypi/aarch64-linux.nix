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
    version = "0.42.0";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/8c/a1/fba52c616631020d6641e1aaf8d2641dccb02cd8ef85c8db15012bbbdf9c/databento_dbn-0.42.0-cp310-cp310-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      sha256 = "sha256-wquCH4cX3XOAGzzpyoIZeEVkt0n5cGhXwxwA95Irfzw=";
    };

    format = "wheel";
  };

  "databento_dbn-python311" = python311Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.42.0";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/cf/63/da262c4c3cd1a6f1e7894f5f5b3e93e28bb333316afeed00c946f1acb7e2/databento_dbn-0.42.0-cp311-cp311-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      sha256 = "sha256-eHnYrc8qzKwf3hdqWwJy/cv6YWWBzoKk9v57HKCI57I=";
    };

    format = "wheel";
  };

  "databento_dbn-python312" = python312Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.42.0";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/b4/1b/71be764538537e9814c0c9deb758882faf624ced7d03390dec8d718c08ea/databento_dbn-0.42.0-cp312-cp312-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      sha256 = "sha256-Ug5VwVYlC6OEdK7xKkqcyYSI2JA+oKP45D7CNK9k9uc=";
    };

    format = "wheel";
  };

  "databento_dbn-python313" = python313Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.42.0";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/c7/34/6476b78e1edec7119d643aa7659ffaf69276f711e55c4255d8890cd23fb5/databento_dbn-0.42.0-cp313-cp313-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      sha256 = "sha256-otCtw0a9SoOIbJdkJsYDx4cs1FcjM6gjcZJTQn46zkQ=";
    };

    format = "wheel";
  };

  "databento_dbn-python39" = python39Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.42.0";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/b1/70/48c315668b1540fd322005f7e5a0e6d6a2cc00e8a887706ed0cacbb308cc/databento_dbn-0.42.0-cp39-cp39-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      sha256 = "sha256-5ihGPgVIZpQUUT+yT26xImMUOjXrQZ8J/zIViwOXGcc=";
    };

    format = "wheel";
  };
}
