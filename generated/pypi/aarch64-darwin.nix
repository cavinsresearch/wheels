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
      url = "https://files.pythonhosted.org/packages/90/53/c6c25941b32124f1c9f667b2908c541d54fc949d73de28d7958051c0e15c/databento_dbn-0.39.0-cp310-cp310-macosx_10_12_x86_64.macosx_11_0_arm64.macosx_10_12_universal2.whl";
      sha256 = "sha256-aMnGCU5+3o2Jc6NCxHCFzUzpaOCIGoZUW4CHcNFPLhc=";
    };

    format = "wheel";
  };

  "databento_dbn-python311" = python311Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.39.0";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/b0/2c/93571b2c9ffab466a61de9dae21acbaed3afc97c82e3aaa319aa527026e7/databento_dbn-0.39.0-cp311-cp311-macosx_10_12_x86_64.macosx_11_0_arm64.macosx_10_12_universal2.whl";
      sha256 = "sha256-Ht9gAgWQKOIiozcrXgtt0H0+iJkbUhnpygRHzWuX25I=";
    };

    format = "wheel";
  };

  "databento_dbn-python312" = python312Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.39.0";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/3e/dc/e111917c518c2a56a1060f7492ec9f10a7a8c82e86e7de9a93130aee2b9b/databento_dbn-0.39.0-cp312-cp312-macosx_10_12_x86_64.macosx_11_0_arm64.macosx_10_12_universal2.whl";
      sha256 = "sha256-bPV++STwQx8JAnZMj83rtKLTFBmut8xC06uFhOUrv0Y=";
    };

    format = "wheel";
  };

  "databento_dbn-python313" = python313Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.39.0";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/a2/c9/97b32e2aafdfc172ca27c4a17fdc859a79908943371f417601c216a97d64/databento_dbn-0.39.0-cp313-cp313-macosx_10_12_x86_64.macosx_11_0_arm64.macosx_10_12_universal2.whl";
      sha256 = "sha256-4orBpZogf2lW9gY+/o8VuzsEL5llYAW07Gb85ei08Cs=";
    };

    format = "wheel";
  };

  "databento_dbn-python39" = python39Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.39.0";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/f2/92/105345abe9bb466062b190075009fe99394ee75afbb1832509b36c3962ca/databento_dbn-0.39.0-cp39-cp39-macosx_10_12_x86_64.macosx_11_0_arm64.macosx_10_12_universal2.whl";
      sha256 = "sha256-/okKy7Oe+D1pTz0GKIZJzQyydiUqRSa6hXOy61I6doU=";
    };

    format = "wheel";
  };
}
