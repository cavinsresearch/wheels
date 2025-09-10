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
      url = "https://files.pythonhosted.org/packages/48/94/a236abf4c7089bc27794d6c87d0c4c95787f3ef042c70c644a8a56317d72/databento_dbn-0.41.0-cp310-cp310-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      sha256 = "sha256-ByFDG8RtY6bxBZb7pBZq8ieNnDVD+SGfEqV7zqnIFHg=";
    };

    format = "wheel";
  };

  "databento_dbn-python311" = python311Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.41.0";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/ae/5a/ded15d57966cd1af10bbe733cd6d38bf7373e8f3739d91b752b74806258e/databento_dbn-0.41.0-cp311-cp311-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      sha256 = "sha256-ioVYtz4K1hkyfzRqZPIwcd5+v0MQ4bMSuP11wTAaFUY=";
    };

    format = "wheel";
  };

  "databento_dbn-python312" = python312Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.41.0";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/8f/e2/2303e568202abf1dddc3703d8d618567a88c949af35ed4412b478b190144/databento_dbn-0.41.0-cp312-cp312-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      sha256 = "sha256-Hy/u6wBe+BWbttuNiV7EesQVvod0hDkRJwrfDyq492k=";
    };

    format = "wheel";
  };

  "databento_dbn-python313" = python313Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.41.0";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/4b/af/8254c13ccdadf9b9a6abcaa8e26800c2f59c740fde033e9355b8e55ca793/databento_dbn-0.41.0-cp313-cp313-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      sha256 = "sha256-Fmi2H9veQzxIeFgUEf7uqGS3jkbFOe2q/B2BkqgE3Dk=";
    };

    format = "wheel";
  };

  "databento_dbn-python39" = python39Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.41.0";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/2f/56/fb97931037824cdd26a6820e4548edc290b2496c139fb8baf585a980c27c/databento_dbn-0.41.0-cp39-cp39-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      sha256 = "sha256-3CVaVPPbjWeMTLoQ2cwFypCSt1ynaRzEGTl22AB2GJ4=";
    };

    format = "wheel";
  };
}
