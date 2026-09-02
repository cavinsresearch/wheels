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
      url = "https://files.pythonhosted.org/packages/80/40/032137914b7605a2563a83a3b6d3bade72ce43a9a2c9fef718e36089e996/databento_dbn-0.69.0-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl";
      sha256 = "sha256-dXnvCQwJpD2i28gSAu/7Yz9eDa5o6rzyCMVjlcOWN1E=";
    };

    format = "wheel";
  };

  "databento_dbn-python311" = python311Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.69.0";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/d0/b5/e1f53955cc33904bb4dc69d453165910268f299646781fef2bda959c4bd5/databento_dbn-0.69.0-cp311-cp311-manylinux_2_17_x86_64.manylinux2014_x86_64.whl";
      sha256 = "sha256-VAiR9dTb+Q5jaGxbAfZa+EDQuZA9yUF75w4EYhTvuQc=";
    };

    format = "wheel";
  };

  "databento_dbn-python312" = python312Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.69.0";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/8c/0e/219d16a55ed8584b5f6f260807a12fb1beab8fab87b3e6a85cea7d054953/databento_dbn-0.69.0-cp312-cp312-manylinux_2_17_x86_64.manylinux2014_x86_64.whl";
      sha256 = "sha256-sVaRN5JByLQPAMUkFcc1nj/qVcEEBAxZQC+N25C46uQ=";
    };

    format = "wheel";
  };

  "databento_dbn-python313" = python313Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.69.0";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/d2/72/12986ec56e1c6641331a8e48946c061610c8518ff57a68bd8fd6f5bd5107/databento_dbn-0.69.0-cp313-cp313-manylinux_2_17_x86_64.manylinux2014_x86_64.whl";
      sha256 = "sha256-TAOQvKMPKRqcQp301IH4tMIX8FS2beEqbYU03g8RboY=";
    };

    format = "wheel";
  };

  "databento_dbn-python314" = python314Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.69.0";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/de/2b/69a0aeb83137105f4f90a5237309afb91d0e941cdcdc90d142036a07a9a5/databento_dbn-0.69.0-cp314-cp314-manylinux_2_17_x86_64.manylinux2014_x86_64.whl";
      sha256 = "sha256-fxPiBOvRwIx1pBlebIJERnFCRpnDw63zoDgz3ci7yKQ=";
    };

    format = "wheel";
  };
}
