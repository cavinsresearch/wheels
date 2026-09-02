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
      url = "https://packages.nautechsystems.io/simple/nautilus-trader/nautilus_trader-1.231.0-cp312-cp312-manylinux_2_35_aarch64.whl";
      sha256 = "sha256-yuPTsN0m6IzkS3XXaWvQGTr2KEbCLPaxnZOShkMIm4M=";
    };

    format = "wheel";
  };

  "nautilus_trader-python313" = python313Packages.buildPythonPackage rec {
    pname = "nautilus_trader";
    version = "1.231.0";

    src = fetchurl {
      url = "https://packages.nautechsystems.io/simple/nautilus-trader/nautilus_trader-1.231.0-cp313-cp313-manylinux_2_35_aarch64.whl";
      sha256 = "sha256-5TbXySWzxHW+9PP451GWlE9rh1hxDkHaEQm4uDcAFpA=";
    };

    format = "wheel";
  };

  "nautilus_trader-python314" = python314Packages.buildPythonPackage rec {
    pname = "nautilus_trader";
    version = "1.231.0";

    src = fetchurl {
      url = "https://packages.nautechsystems.io/simple/nautilus-trader/nautilus_trader-1.231.0-cp314-cp314-manylinux_2_35_aarch64.whl";
      sha256 = "sha256-MQ1sCF3QeG0a7yV8lCahOoeeqO0rJ1sbs7k4S+o7UTA=";
    };

    format = "wheel";
  };
}
