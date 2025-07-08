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
      url = "https://packages.nautechsystems.io/simple/nautilus-trader/nautilus_trader-1.219.0-cp311-cp311-macosx_14_0_arm64.whl";
      sha256 = "sha256-iZd1dPj8rpJfWyjzZgTb3RCMscls0TYt0tGz39I7keo=";
    };

    format = "wheel";
  };

  "nautilus_trader-python312" = python312Packages.buildPythonPackage rec {
    pname = "nautilus_trader";
    version = "1.219.0";

    src = fetchurl {
      url = "https://packages.nautechsystems.io/simple/nautilus-trader/nautilus_trader-1.219.0-cp312-cp312-macosx_14_0_arm64.whl";
      sha256 = "sha256-NJzbkrEbZbIFs7zrKV15T4+MHRkDea+Nv2bdcJIPF8Q=";
    };

    format = "wheel";
  };

  "nautilus_trader-python313" = python313Packages.buildPythonPackage rec {
    pname = "nautilus_trader";
    version = "1.219.0";

    src = fetchurl {
      url = "https://packages.nautechsystems.io/simple/nautilus-trader/nautilus_trader-1.219.0-cp313-cp313-macosx_14_0_arm64.whl";
      sha256 = "sha256-R+sZmoh+KkLuNa6YsP+2hmVziUd1D1kiVa977HAwlCE=";
    };

    format = "wheel";
  };
}
