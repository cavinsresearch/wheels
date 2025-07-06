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
  "nautilus_trader-python311" = python311Packages.buildPythonPackage rec {
    pname = "nautilus_trader";
    version = "1.219.0";

    src = fetchurl {
      url = "https://packages.nautechsystems.io/simple/nautilus-trader/nautilus_trader-1.219.0-cp311-cp311-manylinux_2_35_aarch64.whl";
      sha256 = "sha256-6a6gffFmrQxn2eR8jadwSQ2qUOsH85/ML3XQabtYRnU=";
    };

    format = "wheel";
  };

  "nautilus_trader-python312" = python312Packages.buildPythonPackage rec {
    pname = "nautilus_trader";
    version = "1.219.0";

    src = fetchurl {
      url = "https://packages.nautechsystems.io/simple/nautilus-trader/nautilus_trader-1.219.0-cp312-cp312-manylinux_2_35_aarch64.whl";
      sha256 = "sha256-uW0gIDjX/Oe/YRzENTgNQ4T8+oFPvBgDsyTEpbUC48k=";
    };

    format = "wheel";
  };

  "nautilus_trader-python313" = python313Packages.buildPythonPackage rec {
    pname = "nautilus_trader";
    version = "1.219.0";

    src = fetchurl {
      url = "https://packages.nautechsystems.io/simple/nautilus-trader/nautilus_trader-1.219.0-cp313-cp313-manylinux_2_35_aarch64.whl";
      sha256 = "sha256-sHoCuYqSetplooA0wppAMnbfocMBMiyRiQI4BTjsMEQ=";
    };

    format = "wheel";
  };
}
