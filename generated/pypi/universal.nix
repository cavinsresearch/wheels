# Universal wheels for pythonPackagesExtensions
# These work across all platforms and Python versions
(
  python-final: python-prev: {
    betfair_parser = python-final.buildPythonPackage rec {
      pname = "betfair_parser";
      version = "0.16.1";
      format = "wheel";
      src = python-final.fetchPypi {
        inherit pname version format;
        sha256 = "sha256-57VkQLpWZy7YN2GwH1iV5EDwUuWIQfAyan2otbTeGV4=";
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
      version = "0.57.1";
      format = "wheel";
      src = python-final.fetchPypi {
        inherit pname version format;
        sha256 = "sha256-VMZKI35+d9BELPjgo0g3dyDppZrn/XFRoB38nuZnBpo=";
        dist = "py3";
        python = "py3";
      };
    };
    nautilus_ibapi = python-final.buildPythonPackage rec {
      pname = "nautilus_ibapi";
      version = "10.30.1";
      format = "wheel";
      src = python-final.fetchPypi {
        inherit pname version format;
        sha256 = "sha256-KqDfZU3ka0aZYvUEVBw4igmUhsPpql7bVaQOhJygDtg=";
        dist = "py3";
        python = "py3";
      };
    };
    pandas_gbq = python-final.buildPythonPackage rec {
      pname = "pandas_gbq";
      version = "0.29.1";
      format = "wheel";
      src = python-final.fetchPypi {
        inherit pname version format;
        sha256 = "sha256-Iaqvb2JyOus6h1Hz/Yr/8A9LI3rnIsvmxOefF8hncIY=";
        dist = "py3";
        python = "py3";
      };
    };
  }
)
