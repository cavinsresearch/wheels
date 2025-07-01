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
      url = "https://packages.nautechsystems.io/simple/nautilus-trader/nautilus_trader-1.218.0-cp311-cp311-manylinux_2_35_aarch64.whl";
      sha256 = "sha256-en2S+MpzJtcssE+8YZRVwVABxXCXg2wTiXxzN+bpP6o=";
    };

    format = "wheel";
  };

  "nautilus_trader-python312" = python312Packages.buildPythonPackage rec {
    pname = "nautilus_trader";
    version = "1.218.0";

    src = fetchurl {
      url = "https://packages.nautechsystems.io/simple/nautilus-trader/nautilus_trader-1.218.0-cp312-cp312-manylinux_2_35_aarch64.whl";
      sha256 = "sha256-GHKQiMXsQHDnsVLqAXcme5wo9WeOyrPGdp61PMR6AYA=";
    };

    format = "wheel";
  };

  "nautilus_trader-python313" = python313Packages.buildPythonPackage rec {
    pname = "nautilus_trader";
    version = "1.218.0";

    src = fetchurl {
      url = "https://packages.nautechsystems.io/simple/nautilus-trader/nautilus_trader-1.218.0-cp313-cp313-manylinux_2_35_aarch64.whl";
      sha256 = "sha256-vQgKgTnHxNuvKjrSVHig47k5zfZWp6ZcBRxmu0yPQeg=";
    };

    format = "wheel";
  };
}
