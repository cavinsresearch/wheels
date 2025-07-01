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
      url = "https://packages.nautechsystems.io/simple/nautilus-trader/nautilus_trader-1.218.0-cp311-cp311-manylinux_2_35_x86_64.whl";
      sha256 = "sha256-cDUB2caTm9rJwd0VacgrRmocnfGRuJgpl6CiG3YmDvE=";
    };

    format = "wheel";
  };

  "nautilus_trader-python312" = python312Packages.buildPythonPackage rec {
    pname = "nautilus_trader";
    version = "1.218.0";

    src = fetchurl {
      url = "https://packages.nautechsystems.io/simple/nautilus-trader/nautilus_trader-1.218.0-cp312-cp312-manylinux_2_35_x86_64.whl";
      sha256 = "sha256-Ua2GdvCiITOMgui+J96N01ln0GZlBc5SWKvaAJJDmLY=";
    };

    format = "wheel";
  };

  "nautilus_trader-python313" = python313Packages.buildPythonPackage rec {
    pname = "nautilus_trader";
    version = "1.218.0";

    src = fetchurl {
      url = "https://packages.nautechsystems.io/simple/nautilus-trader/nautilus_trader-1.218.0-cp313-cp313-manylinux_2_35_x86_64.whl";
      sha256 = "sha256-E2iwuuAq/FdDKT2As83mK3rbTLsdoKlFFch3+XSl8iM=";
    };

    format = "wheel";
  };
}
