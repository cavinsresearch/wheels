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
  "nautilus_trader-python312" = python312Packages.buildPythonPackage rec {
    pname = "nautilus_trader";
    version = "1.231.0";

    src = fetchurl {
      url = "https://packages.nautechsystems.io/simple/nautilus-trader/nautilus_trader-1.231.0-cp312-cp312-macosx_26_0_arm64.whl";
      sha256 = "sha256-7ZMEy+3szQPhV8ibHprMPJw1eF87wqEU5OouJioFGJA=";
    };

    format = "wheel";
  };

  "nautilus_trader-python313" = python313Packages.buildPythonPackage rec {
    pname = "nautilus_trader";
    version = "1.231.0";

    src = fetchurl {
      url = "https://packages.nautechsystems.io/simple/nautilus-trader/nautilus_trader-1.231.0-cp313-cp313-macosx_26_0_arm64.whl";
      sha256 = "sha256-uTEr0XywaL2UB882AQP3sjwJqvYRimMh2j3vL+jtqj0=";
    };

    format = "wheel";
  };

  "nautilus_trader-python314" = python314Packages.buildPythonPackage rec {
    pname = "nautilus_trader";
    version = "1.231.0";

    src = fetchurl {
      url = "https://packages.nautechsystems.io/simple/nautilus-trader/nautilus_trader-1.231.0-cp314-cp314-macosx_26_0_arm64.whl";
      sha256 = "sha256-7d+jN545TN+hpRNyLHXL0IM0HsyHomqXNAOMZHsnrms=";
    };

    format = "wheel";
  };
}
