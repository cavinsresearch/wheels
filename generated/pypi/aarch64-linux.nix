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
    version = "0.36.2";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/17/9c/381a9a6ddeb90a221bfdf6c50c8c42f457cee5f81384c3bd14a648d80d12/databento_dbn-0.36.2-cp310-cp310-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      sha256 = "sha256-g6VbQMDTgUaiUHZvEa8kKrH5xlBOusYrdIJNPC3Iau4=";
    };

    format = "wheel";
  };

  "databento_dbn-python311" = python311Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.36.2";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/11/94/06f206e5538d1c62bab8ee90ca350bc183a9e4065774a6d83a73bd5e732e/databento_dbn-0.36.2-cp311-cp311-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      sha256 = "sha256-r15DhOOCeTEDx+92FGf9yutmRvwqFHWucBrMybeMr+o=";
    };

    format = "wheel";
  };

  "databento_dbn-python312" = python312Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.36.2";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/68/60/d2c045ded5072bd3de773d24c1af0c72aedd34bcab947a315c1963f683f4/databento_dbn-0.36.2-cp312-cp312-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      sha256 = "sha256-hJj/xcleI46Js66O55U3oXKG8grDcIBhP2apfVFOllI=";
    };

    format = "wheel";
  };

  "databento_dbn-python313" = python313Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.36.2";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/0e/dd/4872e9b3e809c0c47fd16f2849617af9f3b111c1735f7473ac2765fb3ac3/databento_dbn-0.36.2-cp313-cp313-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      sha256 = "sha256-ItGFyrXN0RxpBcX06uRrngA0540wu9KBrCRNSFO7WvE=";
    };

    format = "wheel";
  };

  "databento_dbn-python39" = python39Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.36.2";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/24/84/6824f42963b606ff4dcc4cb2b1975dd41016861b63cc57c7ec0c00205460/databento_dbn-0.36.2-cp39-cp39-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      sha256 = "sha256-yAeVUa+EW6fPAeFuo9h0LlapgWORAYPH8r8cGzW1K+U=";
    };

    format = "wheel";
  };
}
