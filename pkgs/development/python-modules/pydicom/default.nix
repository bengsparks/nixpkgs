{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchPypi,
  pythonOlder,
  flit-core,
  numpy,
  pytestCheckHook,

  # optional/test dependencies
  gdcm,
  pillow,
  pylibjpeg-libjpeg,
}:
let
  # Pydicom needs pydicom-data to run some tests. If these files aren't downloaded
  # before the package creation, it'll try to download during the checkPhase.
  test_data = buildPythonPackage {
    pname = "pydicom-data";
    version = "1.0.0";

    src = fetchPypi {
      pname = "pydicom-data";
      version = "1.0.0";
      hash = "sha256-k/IJTyGbb+webb7S5QOfuHknL2eGRqNRtGFy9tC/EQ8=";
    };
  };

in
buildPythonPackage rec {
  pname = "pydicom";
  version = "3.0.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "pydicom";
    repo = "pydicom";
    tag = "v${version}";
    hash = "sha256-SvRevQehRaSp+vCtJRQVEJiC5noIJS+bGG1/q4p7/XU=";
  };

  build-system = [ flit-core ];

  dependencies = [
    numpy
  ];

  optional-dependencies = {
    pixeldata = [
      pillow
      #pyjpegls # not in nixpkgs
      #pylibjpeg.optional-dependencies.openjpeg # infinite recursion
      #pylibjpeg.optional-dependencies.rle # not in nixpkgs
      pylibjpeg-libjpeg
      gdcm
    ];
  };

  patches = [
    ./changes.patch
  ];

  nativeCheckInputs = [ pytestCheckHook test_data ] ++ optional-dependencies.pixeldata;

  pytestFlagsArray = [
    "--log-cli-level=debug"
    "tests/test_fileset.py::TestFileSet_Modify::test_remove_list"
  ];

  disabledTests =
    [
      # tries to remove a dicom inside $HOME/.pydicom/data/ and download it again
      "test_fetch_data_files"

      # test_reference_expl{,_binary}[parametric_map_float.dcm] tries to download that file for some reason even though it's present in test-data
      "test_reference_expl"
      "test_reference_expl_binary"

      # slight error in regex matching
      "test_no_decoders_raises"
      "test_deepcopy_bufferedreader_raises"
    ]
    ++ lib.optionals stdenv.hostPlatform.isAarch64 [
      # https://github.com/pydicom/pydicom/issues/1386
      "test_array"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # flaky, hard to reproduce failure outside hydra
      "test_time_check"
    ];

  pythonImportsCheck = [ "pydicom" ];

  meta = with lib; {
    description = "Python package for working with DICOM files";
    mainProgram = "pydicom";
    homepage = "https://pydicom.github.io";
    changelog = "https://github.com/pydicom/pydicom/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
