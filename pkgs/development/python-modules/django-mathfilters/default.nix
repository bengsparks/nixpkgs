{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
}:
buildPythonPackage rec {
  pname = "django-mathfilters";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dbrgn";
    repo = "django-mathfilters";
    tag = "v${version}";
    hash = "sha256-euIZfQvXGEbEcunvimPluU4IXfedEoR0cmKKz7HW3YM=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "mathfilters" "mathfilters.templatetags" ];

  meta = {
    description = "Set of simple math filters for Django";
    homepage = "https://github.com/dbrgn/django-mathfilters";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.bengsparks ];
  };
}