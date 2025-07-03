{ buildPythonPackage, fetchurl, python39Packages, python310Packages, python311Packages, python312Packages, python313Packages, ... }:
{
"databento_dbn-python310" = python310Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.36.1";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/e8/90/f5ae860f07bbdf2142325254ddc1e7a326a7825a0429d14bcf206acdd4a8/databento_dbn-0.36.1-cp310-cp310-macosx_10_12_x86_64.macosx_11_0_arm64.macosx_10_12_universal2.whl";
      sha256 = "sha256-6ZKSUve1tkPBEChYXt4yEWdl+4oQO3AKtXZfahAGux4=";
    };

    format = "wheel";
  };

"databento_dbn-python311" = python311Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.36.1";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/e3/b0/1108cef4ef7a546c9948f628f44db2aa5601f0f17c9026db085a0e1f0448/databento_dbn-0.36.1-cp311-cp311-macosx_10_12_x86_64.macosx_11_0_arm64.macosx_10_12_universal2.whl";
      sha256 = "sha256-teTYqfBOMWYWH253sdC5Cq+hYisHTXTCsA9oDnnUT3M=";
    };

    format = "wheel";
  };

"databento_dbn-python312" = python312Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.36.1";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/a5/12/d193da01538a111872456cee918031799c43e6bc17de4a6126b24a0bf6bd/databento_dbn-0.36.1-cp312-cp312-macosx_10_12_x86_64.macosx_11_0_arm64.macosx_10_12_universal2.whl";
      sha256 = "sha256-bLu6RHhdtk6jHtO/HndQyF5NkjYG3aZcSzVNiHi1Dbw=";
    };

    format = "wheel";
  };

"databento_dbn-python313" = python313Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.36.1";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/3a/d5/11bf72ccb569fc06574fbd7b268e2504ce838a79759c0074bf84bd460cf9/databento_dbn-0.36.1-cp313-cp313-macosx_10_12_x86_64.macosx_11_0_arm64.macosx_10_12_universal2.whl";
      sha256 = "sha256-wk7KqnWcnnjaY6ZIJDXSHIowjeCSyw/qNuBYGfLR7Dc=";
    };

    format = "wheel";
  };

"databento_dbn-python39" = python39Packages.buildPythonPackage rec {
    pname = "databento_dbn";
    version = "0.36.1";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/11/88/f5e5bbcc6737bed7997612b80a3604706b0ead8096fc3c2104fcf377fde3/databento_dbn-0.36.1-cp39-cp39-macosx_10_12_x86_64.macosx_11_0_arm64.macosx_10_12_universal2.whl";
      sha256 = "sha256-zZ5Dkfeo6+m6N6SaYFrF/nc4xXndlS7akogt+Z+jw2s=";
    };

    format = "wheel";
  };
}
