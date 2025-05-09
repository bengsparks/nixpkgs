{
  lib,
  fetchFromGitHub,
  buildPythonPackage,

  # build-system
  setuptools,
  setuptools-scm,

  # nativeCheckInputs
  pytestCheckHook,
  django,
}:
buildPythonPackage rec {
  pname = "swapper";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openwisp";
    repo = "django-swappable-models";
    tag = "v${version}";
    hash = "sha256-YN+i5kC604y5o/2TebBRfc4ySi6r/q9NRLxnK9f+/MA=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  pythonImportsCheck = [ "swapper" ];

  nativeCheckInputs = [
    pytestCheckHook
    django
  ];

  meta = {
    description = "The unofficial Django swappable models API";
    homepage = "https://github.com/fananimi/pyzk";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.bengsparks ];
  };
}
