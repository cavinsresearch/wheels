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
      url = "https://files.pythonhosted.org/packages/64/60/314c11941a7b942a297595ccceb2d62de70d29c44e2e9fd18a4fec7c390f/databento_dbn-0.39.0-cp310-cp310-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      sha256 = "sha256-OEYv7QIKyKpJ9p88/nrOnTe2IGry8+6bc2YqgpLC0wM=";
    };

    format = "wheel";
  };

  "databento_dbn-python311" = python311Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.39.0";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/cc/12/4313f2260869fa9631764894ca11db57f59689a0fb58bb58e15b6ae58e5c/databento_dbn-0.39.0-cp311-cp311-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      sha256 = "sha256-ei89xZ0X87iJZUpwTEgizLlA5Zr3RInDqPGS0nDPQZk=";
    };

    format = "wheel";
  };

  "databento_dbn-python312" = python312Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.39.0";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/ff/1a/970e9c8598db56f41a8d10fd855bac65784f777ba932b84cd84f3d5f036f/databento_dbn-0.39.0-cp312-cp312-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      sha256 = "sha256-AdVRb/udHVnYg696W4Tr9J+mTL1JnhCnhyOf+82+Gpc=";
    };

    format = "wheel";
  };

  "databento_dbn-python313" = python313Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.39.0";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/45/ad/72e510e9bde4bf36275b4e5084ab75d05cf9d897ba56f9f0ac2dafbdf760/databento_dbn-0.39.0-cp313-cp313-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      sha256 = "sha256-w2DGYpl+aLkZ9WrQYKU7A8Sl7mHdkaTzFzuxU5yzC1M=";
    };

    format = "wheel";
  };

  "databento_dbn-python39" = python39Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.39.0";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/3c/62/c18a50e9e416b0f6f333de830b69295b84e88543b503e20798e9503fdf59/databento_dbn-0.39.0-cp39-cp39-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      sha256 = "sha256-CHWQY8AISKZgSXukRDuK/S93kxGabWdH4l5kbS3uJ88=";
    };

    format = "wheel";
  };
}
