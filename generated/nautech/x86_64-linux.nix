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
      url = "https://packages.nautechsystems.io/simple/nautilus-trader/nautilus_trader-1.220.0-cp311-cp311-manylinux_2_35_x86_64.whl";
      sha256 = "sha256-7WkBd7jG+ZP6rxeAGpxrf4nOwZtZRDtGEhaq40CJRok=";
    };

    format = "wheel";
  };

  "nautilus_trader-python312" = python312Packages.buildPythonPackage rec {
    pname = "nautilus_trader";
    version = "1.220.0";

    src = fetchurl {
      url = "https://packages.nautechsystems.io/simple/nautilus-trader/nautilus_trader-1.220.0-cp312-cp312-manylinux_2_35_x86_64.whl";
      sha256 = "sha256-bPwtKjuMGdzbnXXYcxYuNKrIW8COFfSSDuSDuEAVvgU=";
    };

    format = "wheel";
  };

  "nautilus_trader-python313" = python313Packages.buildPythonPackage rec {
    pname = "nautilus_trader";
    version = "1.220.0";

    src = fetchurl {
      url = "https://packages.nautechsystems.io/simple/nautilus-trader/nautilus_trader-1.220.0-cp313-cp313-manylinux_2_35_x86_64.whl";
      sha256 = "sha256-YHS06hNXuF1OLb8A4pN2URGipNqDV72KotbN80K3vio=";
    };

    format = "wheel";
  };
}
