{
  lib,
  stdenv,
  cmake,

  buildPythonPackage,
  fetchFromGitHub,

  setuptools,

  pytestCheckHook,
  pandas,
  polars,
  pyarrow,
}:
let
  driver = stdenv.mkDerivation (finalAttrs: {
    pname = "adbc-driver-postgresql";
    version = "1.10.0";

    src = fetchFromGitHub {
      owner = "apache";
      repo = "arrow-adbc";
      tag = "go/adbc/v${finalAttrs.version}";
      hash = "sha256-HUPYKK81VPQXXsR6N0gCA8g7io7gVwWYy+CVfETrED0=";
    };

    nativeBuildInputs = [ cmake ];

    cmakeFlags = [
      "-S c"
      (lib.cmakeBool "ADBC_BUILD_PYTHON" true)
      (lib.cmakeBool "ADBC_DRIVER_POSTGRESQL" true)
    ];
  });
in
buildPythonPackage (finalAttrs: {
  pname = "adbc-driver-postgresql";
  version = "1.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "apache";
    repo = "arrow-adbc";
    tag = "go/adbc/v${finalAttrs.version}";
    hash = "sha256-HUPYKK81VPQXXsR6N0gCA8g7io7gVwWYy+CVfETrED0=";
  };

  build-system = [ setuptools ];

  preBuild = ''
    export ADBC_POSTGRESQL_LIBRARY=${driver}
    cd python/adbc_driver_postgresql
  '';

  nativeCheckInputs = [
    pytestCheckHook
    pandas
    polars
    pyarrow
  ];

  pythonImportsCheck = [ "adbc_driver_postgresql" ];
})
