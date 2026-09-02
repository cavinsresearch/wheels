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
      url = "https://files.pythonhosted.org/packages/96/d7/3e84304746fe4a098e0c1aa682a6d6d765c6addbb91b914e1463a005efde/databento_dbn-0.69.0-cp310-cp310-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      sha256 = "sha256-O9WZAbTDfi1v9lFPmIaHMbiB9KnG+j85+sgKumA232c=";
    };

    format = "wheel";
  };

  "databento_dbn-python311" = python311Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.69.0";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/c0/4c/cb303d4955a18989be9971ad7f9f2ab4b5ef7b51513477ca25b30f9eeea5/databento_dbn-0.69.0-cp311-cp311-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      sha256 = "sha256-i+4G8xOJIe4AlB+7R/wr2DscHYnUkLWi5Og2kX8uNR8=";
    };

    format = "wheel";
  };

  "databento_dbn-python312" = python312Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.69.0";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/e2/e1/c1b8f0b255dab9b633c230441709f6e07dd60a900e779577c01d74cb6d4b/databento_dbn-0.69.0-cp312-cp312-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      sha256 = "sha256-pcMzSvgdqnnvQnAZe0LToEIur6sBkiJT92uG9pMwl1s=";
    };

    format = "wheel";
  };

  "databento_dbn-python313" = python313Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.69.0";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/46/af/06edcc17b139023322428ddc7216f52b1a53e7b2744a35a8656c797bb70e/databento_dbn-0.69.0-cp313-cp313-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      sha256 = "sha256-+mYJXu3l6caJTs/utQqAGO1gwYWqhhUmoyEq7VUFkUY=";
    };

    format = "wheel";
  };

  "databento_dbn-python314" = python314Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.69.0";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/6c/2e/357db817dd9b1c6fd05fd8af24e395dff10edca629d5b75c22e8b2cb277d/databento_dbn-0.69.0-cp314-cp314-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      sha256 = "sha256-XiiQUyAe1w8KZkDRLeuEjF8KPwL5eTCs90RQ4MGb+kw=";
    };

    format = "wheel";
  };
}
