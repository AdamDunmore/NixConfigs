
{ lib
, buildPythonPackage
, fetchFromGitHub
, beets
, pyyaml
, setuptools
}:

buildPythonPackage {
  pname = "beets-xtractor";
  version = "0.1.0"; # Replace with upstream version
  pyproject = false;

  src = fetchFromGitHub {
    owner = "adamjakab";
    repo = "BeetsPluginXtractor";
    rev = "master";
    hash = lib.fakeHash;
  };

  nativeBuildInputs = [ setuptools ];
  propagatedBuildInputs = [ beets pyyaml ];

  pythonImportsCheck = [ "beetsplug.xtractor" ];

  meta = {
    description = "Musical feature extraction plugin for Beets";
    homepage = "https://github.com/adamjakab/BeetsPluginXtractor";
    license = lib.licenses.mit;
  };
}

