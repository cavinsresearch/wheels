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
    version = "1.218.0";

    src = fetchurl {
      url = "https://packages.nautechsystems.io/simple/nautilus-trader/nautilus_trader-1.218.0-cp311-cp311-macosx_14_0_arm64.whl";
      sha256 = "sha256-pmSYCjDIlyaDoW2OOlwzSK3UC8rDBps8kBKBRxySt+w=";
    };

    format = "wheel";
  };

  "nautilus_trader-python312" = python312Packages.buildPythonPackage rec {
    pname = "nautilus_trader";
    version = "1.218.0";

    src = fetchurl {
      url = "https://packages.nautechsystems.io/simple/nautilus-trader/nautilus_trader-1.218.0-cp312-cp312-macosx_14_0_arm64.whl";
      sha256 = "sha256-ipx+YcB2C0hG0tY8gaVXvyevDs+BBoFifWKPOF2VzPM=";
    };

    format = "wheel";
  };

  "nautilus_trader-python313" = python313Packages.buildPythonPackage rec {
    pname = "nautilus_trader";
    version = "1.218.0";

    src = fetchurl {
      url = "https://packages.nautechsystems.io/simple/nautilus-trader/nautilus_trader-1.218.0-cp313-cp313-macosx_14_0_arm64.whl";
      sha256 = "sha256-xljvmtSJgUNUDw5LIrlSI+RS3HXrQmbqc04qi26NgHw=";
    };

    format = "wheel";
  };
}
