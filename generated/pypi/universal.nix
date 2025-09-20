# Universal wheels for pythonPackagesExtensions
# These work across all platforms and Python versions
(
  python-final: python-prev: {
    betfair_parser = python-final.buildPythonPackage rec {
      pname = "betfair_parser";
      version = "0.17";
      format = "wheel";
      src = python-final.fetchPypi {
        inherit pname version format;
        sha256 = "sha256-Ij6tkeOGL+T6MoqhdtIDzbEBGVDv6RaHps6wS9PXKmA=";
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
      version = "0.63.0";
      format = "wheel";
      src = python-final.fetchPypi {
        inherit pname version format;
        sha256 = "sha256-WhakCcojLOm1hDYk5cNXNeDwOqdvg4w/YcSJr03gBDo=";
        dist = "py3";
        python = "py3";
      };
    };
    pandas_gbq = python-final.buildPythonPackage rec {
      pname = "pandas_gbq";
      version = "0.29.2";
      format = "wheel";
      src = python-final.fetchPypi {
        inherit pname version format;
        sha256 = "sha256-mfa2Qr2DQOlsKs331xcQiqDTHHA8LyhIF7p9w7FhELI=";
        dist = "py3";
        python = "py3";
      };
    };
  }
)
