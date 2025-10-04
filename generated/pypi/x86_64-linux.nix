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
      url = "https://files.pythonhosted.org/packages/26/4d/f67cffbe32ff374d69ee69ad9b2cb46f5b3d28578c7c5fe75a99f9eff31b/databento_dbn-0.42.0-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl";
      sha256 = "sha256-+mgGURfrF9sqNd0wr/zi3Q3HHBUVkz8bYS2Tf2Vt4rI=";
    };

    format = "wheel";
  };

  "databento_dbn-python311" = python311Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.42.0";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/56/45/58172b6e28d43204febf90d9766f3654950b462b28699dfe7bc9677d410c/databento_dbn-0.42.0-cp311-cp311-manylinux_2_17_x86_64.manylinux2014_x86_64.whl";
      sha256 = "sha256-y/vAptBAhUpjj8WaqALyM6OTQRRHTKIHr36oZCq40oE=";
    };

    format = "wheel";
  };

  "databento_dbn-python312" = python312Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.42.0";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/d3/e1/85188deb43dabe9779c2b2c509d8c722dcf6a1759ed44092e6ca2dce2e4a/databento_dbn-0.42.0-cp312-cp312-manylinux_2_17_x86_64.manylinux2014_x86_64.whl";
      sha256 = "sha256-X1K6iAlAqsJaWMneHPRHJ7P8NSr87439LRwCT+TnGd4=";
    };

    format = "wheel";
  };

  "databento_dbn-python313" = python313Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.42.0";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/23/b0/f0b8baa875f029fc5c880b2910293e55db29690ffc8f0751c87b513816f1/databento_dbn-0.42.0-cp313-cp313-manylinux_2_17_x86_64.manylinux2014_x86_64.whl";
      sha256 = "sha256-9bankqyDXuav27PC4O+2bV/M+Eh2pSGkLK+Q6DDfVd0=";
    };

    format = "wheel";
  };

  "databento_dbn-python39" = python39Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.42.0";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/0c/64/98a2f8915347b31ccd2fac1f0be54f17c6c40ff773b6c28da23accff68a9/databento_dbn-0.42.0-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl";
      sha256 = "sha256-QgF1aNHQ57TGhtikun3D+wzZUuIRQbsI2jthChCPJ0M=";
    };

    format = "wheel";
  };
}
