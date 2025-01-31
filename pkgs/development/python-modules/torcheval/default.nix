{
  # Python package building
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:
let
  pname = "torcheval";
  version = "0.0.6";
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  # Prefer to fetch from GitHub because tests are missing in Pypi release
  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "torcheval";
    tag = version;
    hash = "sha256-FnMSPU8tjXegLH4speeyD8UDrKSvjf8STftt7aXTuJI=";
  };

  buildInputs = [ setuptools ];
}
