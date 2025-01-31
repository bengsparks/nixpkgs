{
  buildPythonPackage,
  fetchPypi,
  # requirements.txt
  torch,
  numpy_1,
  fsspec,
  tensorboard,
  psutil,
  pyre-extensions,
  typing-extensions,
  setuptools,
  tqdm,
  tabulate,
}:
let
  pname = "torchtnt-nightly";
  version = "2023.1.25";

in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  # The GitHub repo has no tag, so we fallback to Pypi instead
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-eFouZgdVQaqrXIKLY7geLV8GEVPGu6IHKIPK6aLJH8w=";
  };

  # requirements.txt
  dependencies = [
    torch
    numpy_1
    fsspec
    tensorboard
    psutil
    pyre-extensions
    typing-extensions
    setuptools
    tqdm
    tabulate
  ];

  # The pypi archive has no tests
  doCheck = false;

  pythonImportsCheck = [
    "torchtnt"
  ];
}
