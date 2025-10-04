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
      url = "https://files.pythonhosted.org/packages/82/74/2bf93b744f71e71db34a027b0ee0ce6af02f47c90df060c8d533b62a00ab/databento_dbn-0.42.0-cp310-cp310-macosx_10_12_x86_64.macosx_11_0_arm64.macosx_10_12_universal2.whl";
      sha256 = "sha256-Xw86zk8V0z3Vhopp4eq2aPXBU5at5Zca78toJ04XHx4=";
    };

    format = "wheel";
  };

  "databento_dbn-python311" = python311Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.42.0";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/a8/c1/3ca921ae97d92d07faf583935b93da56eec0f1fbfa0af76f72b1beaf56e2/databento_dbn-0.42.0-cp311-cp311-macosx_10_12_x86_64.macosx_11_0_arm64.macosx_10_12_universal2.whl";
      sha256 = "sha256-WlHWgWkeHB4YiHMNpzQJf2uZejsqcfGfo3pSOdCjBDA=";
    };

    format = "wheel";
  };

  "databento_dbn-python312" = python312Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.42.0";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/4f/d8/e9554f64cc831b1470e60b0fda74b242ed549b7f0986e40ed818eef6eb4f/databento_dbn-0.42.0-cp312-cp312-macosx_10_12_x86_64.macosx_11_0_arm64.macosx_10_12_universal2.whl";
      sha256 = "sha256-DhGz0Ol0J5WgYSYtq7yTTkEapjw143RSj3U2pffrMIY=";
    };

    format = "wheel";
  };

  "databento_dbn-python313" = python313Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.42.0";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/63/e9/043a4015911446274f702bb9522efe425ad13d3912ebe36a76bf5f63d98a/databento_dbn-0.42.0-cp313-cp313-macosx_10_12_x86_64.macosx_11_0_arm64.macosx_10_12_universal2.whl";
      sha256 = "sha256-b5iR9mZm5+wyChoelmKM6l0c3MKqgorWe8BfAdTCl6o=";
    };

    format = "wheel";
  };

  "databento_dbn-python39" = python39Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.42.0";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/b3/48/bb46774cb1e6486de54ffef04534f86ba385adb4bdfe0c1d00062d3d28ad/databento_dbn-0.42.0-cp39-cp39-macosx_10_12_x86_64.macosx_11_0_arm64.macosx_10_12_universal2.whl";
      sha256 = "sha256-Kk/G2okQhkdJuSpYCKm5GlL0dYj0pQqUzglOSDwaN+E=";
    };

    format = "wheel";
  };
}
