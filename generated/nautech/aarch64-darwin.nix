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
    version = "1.220.0";

    src = fetchurl {
      url = "https://packages.nautechsystems.io/simple/nautilus-trader/nautilus_trader-1.220.0-cp311-cp311-macosx_15_0_arm64.whl";
      sha256 = "sha256-XgafEvw9WPIVDzBbRqup7nwXgAWnit0GflgyIy33LpY=";
    };

    format = "wheel";
  };

  "nautilus_trader-python312" = python312Packages.buildPythonPackage rec {
    pname = "nautilus_trader";
    version = "1.220.0";

    src = fetchurl {
      url = "https://packages.nautechsystems.io/simple/nautilus-trader/nautilus_trader-1.220.0-cp312-cp312-macosx_15_0_arm64.whl";
      sha256 = "sha256-UGolIz6e6pj9WHegAIIOIjfV3zPwWRJu4Q78MQ/7yDw=";
    };

    format = "wheel";
  };

  "nautilus_trader-python313" = python313Packages.buildPythonPackage rec {
    pname = "nautilus_trader";
    version = "1.220.0";

    src = fetchurl {
      url = "https://packages.nautechsystems.io/simple/nautilus-trader/nautilus_trader-1.220.0-cp313-cp313-macosx_15_0_arm64.whl";
      sha256 = "sha256-StyAnDF0BiU3zNUjOgDO9n3QjKZAF+Jgx9Tk5Wimy0o=";
    };

    format = "wheel";
  };
}
