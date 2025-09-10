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
      url = "https://files.pythonhosted.org/packages/3b/92/e264c645fb6e4c76524ecc458a15b1cc3f82398843a84f5fdb2b8c752d5e/databento_dbn-0.41.0-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl";
      sha256 = "sha256-d5uhefSvaXsckBZwJ+6/PaCGhldHJBTK3s1sbuURiZY=";
    };

    format = "wheel";
  };

  "databento_dbn-python311" = python311Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.41.0";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/d7/b8/851d7a116f948b1e4592fa23e4d9b50e458d0668b2175572659ddd43db4f/databento_dbn-0.41.0-cp311-cp311-manylinux_2_17_x86_64.manylinux2014_x86_64.whl";
      sha256 = "sha256-MZ0FccJgYk6kpeGRTVIdQVdPOjLdbNzBXTLZwTPRgJo=";
    };

    format = "wheel";
  };

  "databento_dbn-python312" = python312Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.41.0";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/05/a4/eca45ead595784d4c79ed8447ac525fb4d20cdfee1a3bd579d0f46efb6ed/databento_dbn-0.41.0-cp312-cp312-manylinux_2_17_x86_64.manylinux2014_x86_64.whl";
      sha256 = "sha256-tZf78NXOURXCG9nJnUa5003l4IvuP8fts2v5lqRv2Bc=";
    };

    format = "wheel";
  };

  "databento_dbn-python313" = python313Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.41.0";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/6c/ed/a98eaf4f9fa96c3d52cdb67287b1a53ca3319c113aed9f61bf02e5ae86ef/databento_dbn-0.41.0-cp313-cp313-manylinux_2_17_x86_64.manylinux2014_x86_64.whl";
      sha256 = "sha256-ChLMYqOuoyuresP+3oscRI8d68J35gOX/cD/oQYAWA0=";
    };

    format = "wheel";
  };

  "databento_dbn-python39" = python39Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.41.0";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/55/cc/914f0a857d73206d21150ecf5db473b956de558506fb35ef53671a08469a/databento_dbn-0.41.0-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl";
      sha256 = "sha256-oOKfsMLN1sOvpLazZDtWZQlJqdbtFd3/sacqQEgCkNU=";
    };

    format = "wheel";
  };
}
