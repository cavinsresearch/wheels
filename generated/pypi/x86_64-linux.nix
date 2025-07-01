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
    version = "0.36.1";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/66/0b/09d46de2f07ae3763c6e5e34d7892f5dc428d0fab9f08883e4a557455ab0/databento_dbn-0.36.1-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl";
      sha256 = "sha256-YHc3UmIpMicXfmNgZLCbS1sEOEpGFBcPrzIVPhu6ECg=";
    };

    format = "wheel";
  };

  "databento_dbn-python311" = python311Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.36.1";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/db/5b/01911d251e5aaa305ac16cf583e34d31e0a7a0df103f3163285aaa6033ad/databento_dbn-0.36.1-cp311-cp311-manylinux_2_17_x86_64.manylinux2014_x86_64.whl";
      sha256 = "sha256-LdvJ3B2g7X7AU4Xg7DHwQa/kzFY3O5ZSSsYWkN3ghYI=";
    };

    format = "wheel";
  };

  "databento_dbn-python312" = python312Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.36.1";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/1b/d8/826727b9127fcd86977eec5945c606dbf751af5a56ad7d140cb7c822151f/databento_dbn-0.36.1-cp312-cp312-manylinux_2_17_x86_64.manylinux2014_x86_64.whl";
      sha256 = "sha256-BqOmwplPl5n9/Z+fgHjZgEe/F7pvLLxsMpQFGFJ9ftE=";
    };

    format = "wheel";
  };

  "databento_dbn-python313" = python313Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.36.1";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/79/1f/46cd34fc76bb97b3e16b0c41d30c34d138feee30d9007f4a1ffbc287fd3e/databento_dbn-0.36.1-cp313-cp313-manylinux_2_17_x86_64.manylinux2014_x86_64.whl";
      sha256 = "sha256-smrT6BqcMAWb1BLIFbp2WPrvSwBnz5bwveGrfJh9bNw=";
    };

    format = "wheel";
  };

  "databento_dbn-python39" = python39Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.36.1";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/10/26/fcf71a58d7a91943bc1707e7d7b8e6ae4039cd3dd652966e8a8a63e25532/databento_dbn-0.36.1-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl";
      sha256 = "sha256-tsVzmgB3UmPtxbLySN/9sFrRmEts5hgehEMY377H3B4=";
    };

    format = "wheel";
  };
}
