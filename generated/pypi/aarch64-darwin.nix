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
      url = "https://files.pythonhosted.org/packages/20/30/971eef388c8c9df414dbe8bb98f9932332d550cfe5d1207874412a9b88fd/databento_dbn-0.36.2-cp310-cp310-macosx_10_12_x86_64.macosx_11_0_arm64.macosx_10_12_universal2.whl";
      sha256 = "sha256-m3JwZ0W5GVo2Cjo3WWPtMK8hFrUkGmMPBuL+r1blz3I=";
    };

    format = "wheel";
  };

  "databento_dbn-python311" = python311Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.36.2";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/52/59/984e2a807f4ce22adab22b3a207495fc88b73c43966be79979c2049f1665/databento_dbn-0.36.2-cp311-cp311-macosx_10_12_x86_64.macosx_11_0_arm64.macosx_10_12_universal2.whl";
      sha256 = "sha256-2t2CUvLpvGlOh46Gq2cH6eEpNyqD3pVEJ3PRidYG52I=";
    };

    format = "wheel";
  };

  "databento_dbn-python312" = python312Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.36.2";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/01/d4/843f241eda207c3d69934beee239bfc46ba237491872461f4658326ea572/databento_dbn-0.36.2-cp312-cp312-macosx_10_12_x86_64.macosx_11_0_arm64.macosx_10_12_universal2.whl";
      sha256 = "sha256-XAOuMuOdeoEB6WSHYr6AW/8hMRxSOCGAS1xhN9BwAso=";
    };

    format = "wheel";
  };

  "databento_dbn-python313" = python313Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.36.2";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/9c/35/a6c084f5e09be529f4b9edf81d63ef4fc3e1f62d92f8054bfe51761012b4/databento_dbn-0.36.2-cp313-cp313-macosx_10_12_x86_64.macosx_11_0_arm64.macosx_10_12_universal2.whl";
      sha256 = "sha256-Hb16kV8FCjVJycuDM6TmaJe3J/luH/IHvTqyUGnWsvQ=";
    };

    format = "wheel";
  };

  "databento_dbn-python39" = python39Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.36.2";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/0c/5b/43bec9ed63176d1cec3061be0cfcfb2ecc8557e6dc5ea46575e2ebeaa846/databento_dbn-0.36.2-cp39-cp39-macosx_10_12_x86_64.macosx_11_0_arm64.macosx_10_12_universal2.whl";
      sha256 = "sha256-tL91aBPUHGbu+Fz8gVVpCn43RVlWPZclse0WaaSuB8c=";
    };

    format = "wheel";
  };
}
