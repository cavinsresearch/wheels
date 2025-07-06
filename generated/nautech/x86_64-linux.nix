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
      url = "https://packages.nautechsystems.io/simple/nautilus-trader/nautilus_trader-1.219.0-cp311-cp311-manylinux_2_35_x86_64.whl";
      sha256 = "sha256-P1kcX9GEKgy5wPXTaX0faOFQd1Hp0XU+rSWVdoUoVhE=";
    };

    format = "wheel";
  };

  "nautilus_trader-python312" = python312Packages.buildPythonPackage rec {
    pname = "nautilus_trader";
    version = "1.219.0";

    src = fetchurl {
      url = "https://packages.nautechsystems.io/simple/nautilus-trader/nautilus_trader-1.219.0-cp312-cp312-manylinux_2_35_x86_64.whl";
      sha256 = "sha256-+Oy0F8fI+FCsvWEHos3WXFAwl8YqiMMzPfJVZPG10Lo=";
    };

    format = "wheel";
  };

  "nautilus_trader-python313" = python313Packages.buildPythonPackage rec {
    pname = "nautilus_trader";
    version = "1.219.0";

    src = fetchurl {
      url = "https://packages.nautechsystems.io/simple/nautilus-trader/nautilus_trader-1.219.0-cp313-cp313-manylinux_2_35_x86_64.whl";
      sha256 = "sha256-P35rFm8E+6V2bHgqJmj867U6Q6gl5bIqh7iUK2PTbaw=";
    };

    format = "wheel";
  };
}
