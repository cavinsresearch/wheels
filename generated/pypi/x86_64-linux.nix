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
      url = "https://files.pythonhosted.org/packages/35/8a/c3574a8d59823a1e507b17945a9e5bf1614f6aaefa1d3f074457e9a9023c/databento_dbn-0.36.2-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl";
      sha256 = "sha256-1Xq9BVy90ns3yTiJ3EPV53Mx4rpoehxNmM5tNgGjM9k=";
    };

    format = "wheel";
  };

  "databento_dbn-python311" = python311Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.36.2";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/c3/7f/4a2dc38ffe7f7a8cd5e0e108237a7044044e99f933cfa6e3a48a6a6a59ab/databento_dbn-0.36.2-cp311-cp311-manylinux_2_17_x86_64.manylinux2014_x86_64.whl";
      sha256 = "sha256-Je0fFjqt/oTbYu/DvB0QrqavPhNdZpE8gK8yKjVgbBg=";
    };

    format = "wheel";
  };

  "databento_dbn-python312" = python312Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.36.2";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/36/de/bd6bafd6fbb96cbb7140486ec986eab36dbb777e3abb88f124f6f8265dc8/databento_dbn-0.36.2-cp312-cp312-manylinux_2_17_x86_64.manylinux2014_x86_64.whl";
      sha256 = "sha256-MCb5nVxiz+Qbs3zAYUZYX8b9bC23vb7rATVXO7Q83T8=";
    };

    format = "wheel";
  };

  "databento_dbn-python313" = python313Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.36.2";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/d6/2f/76bf795c214e0c85c7c31778db328703c7c07db697851507022f1e9abe07/databento_dbn-0.36.2-cp313-cp313-manylinux_2_17_x86_64.manylinux2014_x86_64.whl";
      sha256 = "sha256-HAijIfT4Ua3FTHdnz3MYIdK6WDDp+cfzHWUucb61GZk=";
    };

    format = "wheel";
  };

  "databento_dbn-python39" = python39Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.36.2";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/fe/82/ff1dc5160334eb58d997b39315e6a7d58a6c870a0bf710d2865569bd21d3/databento_dbn-0.36.2-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl";
      sha256 = "sha256-zKFYc72E+/jem3RhjjhJ0yN/o6CvkLZVtPapjsZbLmk=";
    };

    format = "wheel";
  };
}
