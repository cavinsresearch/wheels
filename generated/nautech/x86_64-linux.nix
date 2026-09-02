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
      url = "https://packages.nautechsystems.io/simple/nautilus-trader/nautilus_trader-1.231.0-cp312-cp312-manylinux_2_35_x86_64.whl";
      sha256 = "sha256-jEOOlcJ1oT3wwN23ASxGJwi16Z/zYS42obe9Sas5whY=";
    };

    format = "wheel";
  };

  "nautilus_trader-python313" = python313Packages.buildPythonPackage rec {
    pname = "nautilus_trader";
    version = "1.231.0";

    src = fetchurl {
      url = "https://packages.nautechsystems.io/simple/nautilus-trader/nautilus_trader-1.231.0-cp313-cp313-manylinux_2_35_x86_64.whl";
      sha256 = "sha256-Qp6mHDOjLNhJjTng6pXrqhK42/wlxx+6uoRfKwXoq5E=";
    };

    format = "wheel";
  };

  "nautilus_trader-python314" = python314Packages.buildPythonPackage rec {
    pname = "nautilus_trader";
    version = "1.231.0";

    src = fetchurl {
      url = "https://packages.nautechsystems.io/simple/nautilus-trader/nautilus_trader-1.231.0-cp314-cp314-manylinux_2_35_x86_64.whl";
      sha256 = "sha256-/Aqp6hRiijCv3M4hboy5TxHnM9g+2z4Yg/2zC2yjVYY=";
    };

    format = "wheel";
  };
}
