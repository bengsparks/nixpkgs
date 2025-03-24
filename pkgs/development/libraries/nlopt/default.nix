{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  # Optionally build python bindings
  withPython ? false,
  # Optionally build octave bindings
  withOctave ? false,
  # For retrieving optional dependencies related to the aforementioned bindings
  pkgs,
}:
let
  pythonEnv = pkgs.python3.withPackages (p: [ p.numpy ]);
in
stdenv.mkDerivation rec {
  pname = "nlopt";
  version = "2.7.1";

  src = fetchFromGitHub {
    owner = "stevengj";
    repo = pname;
    tag = "v${version}";
    sha256 = "sha256-TgieCX7yUdTAEblzXY/gCN0r6F9TVDh4RdNDjQdXZ1o=";
  };

  nativeBuildInputs =
    [ cmake ]
    ## The octave bindings are vendored within the repository, and therefore do not require further effort.
    ##
    ## Building the python bindings requires SWIG, and numpy in addition to the CXX routines.
    ## The tests also make use of the same interpreter to test the bindings.
    ++ lib.optionals withPython [ pkgs.swig pythonEnv ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=OFF"
    "-DNLOPT_CXX=ON"
    "-DNLOPT_PYTHON=${if withPython then "ON" else "OFF"}"
    "-DNLOPT_OCTAVE=${if withOctave then "ON" else "OFF"}"
    "-DNLOPT_MATLAB=OFF"
    "-DNLOPT_GUILE=OFF"
    "-DNLOPT_SWIG=${if withPython then "ON" else "OFF"}"
  ] ++ lib.optional withPython "-DPython_EXECUTABLE=${pythonEnv.interpreter}";

  doCheck = true;

  postFixup = ''
    substituteInPlace $out/lib/cmake/nlopt/NLoptLibraryDepends.cmake --replace-fail \
      'INTERFACE_INCLUDE_DIRECTORIES "''${_IMPORT_PREFIX}/' 'INTERFACE_INCLUDE_DIRECTORIES "'
  '';

  meta = {
    homepage = "https://nlopt.readthedocs.io/en/latest/";
    description = "Free open-source library for nonlinear optimization";
    license = lib.licenses.lgpl21Plus;
    hydraPlatforms = lib.platforms.linux;
  };

}
