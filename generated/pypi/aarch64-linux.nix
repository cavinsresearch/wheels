{ buildPythonPackage, fetchurl, python39Packages, python310Packages, python311Packages, python312Packages, python313Packages, ... }:
{
"databento_dbn-python310" = python310Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.36.1";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/c6/61/6c0f952e9539d8f0f297d637f785b03e2fe3dbcf4c5dcb2b91ac7ec2b0f4/databento_dbn-0.36.1-cp310-cp310-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      sha256 = "sha256-oSsd8m7F35CknSsd63P5YZnAPtqr4wlhJJEzvp828UQ=";
    };

    format = "wheel";
  };

"databento_dbn-python311" = python311Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.36.1";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/c0/b9/da785ac69cb2d381e6e2e93a32b426bbd90bb38cd068c0ec7368f09fbf4b/databento_dbn-0.36.1-cp311-cp311-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      sha256 = "sha256-0rLjLNPyN3Wo/IVpArmWiL02Baa5caY8jYfMF4HSiUM=";
    };

    format = "wheel";
  };

"databento_dbn-python312" = python312Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.36.1";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/4f/83/dd8d974a048828413fec8186d20a8b0785c4c2fae882211535163d2c47b7/databento_dbn-0.36.1-cp312-cp312-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      sha256 = "sha256-M1TG7fvs/btCqAfOFJMiCtFsSZEkAHLvORHCOLW+elA=";
    };

    format = "wheel";
  };

"databento_dbn-python313" = python313Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.36.1";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/b9/c4/d91f9d42a45a400a70aca848c43dac2f6a828a999c13a93c6eba5ed6fad9/databento_dbn-0.36.1-cp313-cp313-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      sha256 = "sha256-MlebQ6q71SiYDLSx2Qiq/d3ZBvx7i/S+pN9v134WLVU=";
    };

    format = "wheel";
  };

"databento_dbn-python39" = python39Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.36.1";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/fb/de/08ecc8a42c67059360e86c9f7662e8a06395bdc0fee7dc0c20a795c30f14/databento_dbn-0.36.1-cp39-cp39-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      sha256 = "sha256-muDyiR0v4dn1snrBOd0a7Gi6ThfVJHCh8AS3YwQRPu8=";
    };

    format = "wheel";
  };
}
