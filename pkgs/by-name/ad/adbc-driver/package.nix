{
  lib,
  stdenv,
  cmake,
  fmt,
  libpq,
  pkg-config,
  python3,

  fetchFromGitHub,
}:
assert !stdenv.hostPlatform.isStatic;
stdenv.mkDerivation (finalAttrs: {
  pname = "adbc-driver-postgresql";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "arrow-adbc";
    tag = "go/adbc/v${finalAttrs.version}";
    hash = "sha256-HUPYKK81VPQXXsR6N0gCA8g7io7gVwWYy+CVfETrED0=";
  };

  postPatch = "pushd c";

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ fmt libpq python3 ];

  cmakeFlags = [
    (lib.cmakeBool "ADBC_BUILD_PYTHON" true)
    (lib.cmakeBool "ADBC_DRIVER_POSTGRESQL" true)
    (lib.cmakeBool "ADBC_WITH_VENDORED_FMT" false)
    (lib.cmakeBool "ADBC_WITH_VENDORED_NANOARROW" true)
    (lib.cmakeBool "ADBC_BUILD_TESTS" (finalAttrs.finalPackage.doCheck))
    (lib.cmakeBool "ADBC_BUILD_BENCHMARKS" false)
  ];

  buildPhase = ''

  '';

  postBuild = ''
    popd
  '';
})
