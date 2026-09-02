# Universal wheels for pythonPackagesExtensions
# These work across all platforms and Python versions
(
  python-final: python-prev: {
    betfair_parser = python-final.buildPythonPackage rec {
      pname = "betfair_parser";
      version = "0.19.3";
      format = "wheel";
      src = python-final.fetchPypi {
        inherit pname version format;
        sha256 = "sha256-OAqXlEjc0XD+2e0w2ICwOIZDx/v5yark5GLgjiue0Ng=";
        dist = "py3";
        python = "py3";
      };
    };
    bybit_history = python-final.buildPythonPackage rec {
      pname = "bybit_history";
      version = "0.1.3";
      format = "wheel";
      src = python-final.fetchPypi {
        inherit pname version format;
        sha256 = "sha256-MkcKTT23KTFrbUftnzXsqxrBwtsRNFufP+zK8cMGARM=";
        dist = "py3";
        python = "py3";
      };
    };
    databento = python-final.buildPythonPackage rec {
      pname = "databento";
      version = "0.86.0";
      format = "wheel";
      src = python-final.fetchPypi {
        inherit pname version format;
        sha256 = "sha256-BapPl9/sPgoYzmxfqYKD4XH17leTZM4y1KXrbERoZ/k=";
        dist = "py3";
        python = "py3";
      };
    };
    nautilus_ibapi = python-final.buildPythonPackage rec {
      pname = "nautilus_ibapi";
      version = "10.46.1";
      format = "wheel";
      src = python-final.fetchPypi {
        inherit pname version format;
        sha256 = "sha256-W02ShRZq0KD/uPvj3CKekKJoxDlvvFMdGBkVblt/jiY=";
        dist = "py3";
        python = "py3";
      };
    };
    pandas_gbq = python-final.buildPythonPackage rec {
      pname = "pandas_gbq";
      version = "0.35.2";
      format = "wheel";
      src = python-final.fetchPypi {
        inherit pname version format;
        sha256 = "sha256-t0GH7JGyXKSBixQ0P3p2Wn7o97Ptfo0eQo6eiiCUsOg=";
        dist = "py3";
        python = "py3";
      };
    };
  }
)
