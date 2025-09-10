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
      url = "https://packages.nautechsystems.io/simple/nautilus-trader/nautilus_trader-1.220.0-cp311-cp311-manylinux_2_35_aarch64.whl";
      sha256 = "sha256-9XkdVo5l49ck72qm6yocqNr+3XLsOdCgslDqaEDKurE=";
    };

    format = "wheel";
  };

  "nautilus_trader-python312" = python312Packages.buildPythonPackage rec {
    pname = "nautilus_trader";
    version = "1.220.0";

    src = fetchurl {
      url = "https://packages.nautechsystems.io/simple/nautilus-trader/nautilus_trader-1.220.0-cp312-cp312-manylinux_2_35_aarch64.whl";
      sha256 = "sha256-Ia7o+gy8KPQ2SHBSkVr8/713dgKHQ1lWM3V/w2z15fk=";
    };

    format = "wheel";
  };

  "nautilus_trader-python313" = python313Packages.buildPythonPackage rec {
    pname = "nautilus_trader";
    version = "1.220.0";

    src = fetchurl {
      url = "https://packages.nautechsystems.io/simple/nautilus-trader/nautilus_trader-1.220.0-cp313-cp313-manylinux_2_35_aarch64.whl";
      sha256 = "sha256-FQ5EeJSRr2pIK/PL+Zy2vEiGgBbDBImFsx70DhSKcNY=";
    };

    format = "wheel";
  };
}
