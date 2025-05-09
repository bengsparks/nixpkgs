{
  lib,
  fetchFromGitHub,
  buildPythonPackage,

  # build-system
  setuptools,

  # nativeCheckInputs
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "pyzk";
  version = "0.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fananimi";
    repo = "pyzk";
    tag = version;
    hash = "sha256-Wqmq484oaaJJFq3FqbFkolkRxLlM8bpHTt30vsz2cuQ=";
  };

  build-system = [ setuptools ];

  pythonRemoveDeps = [ "future" ];

  pythonImportsCheck = [ "zk" ];

  # nativeCheckInputs = [ pytestCheckHook ];

  # disabledTestPaths = [ "example" ];

  meta = {
    description = "Unofficial library of zkteco fingerprint attendance machine";
    homepage = "https://github.com/fananimi/pyzk";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.bengsparks ];
  };
}