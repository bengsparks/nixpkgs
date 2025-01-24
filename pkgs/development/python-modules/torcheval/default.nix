{
  # Python package building
  buildPythonPackage,
  callPackage,
  fetchFromGitHub,
  setuptools,
  ## requirements.txt
  typing-extensions,
  ## dev-requirements.txt
  numpy,
  torchvision,
  pytest-timeout,
  cython_0,
  scikit-learn,
  pytestCheckHook,
  # meta
  lib,
}:
let
  pname = "torcheval";
  version = "0.0.6";

  # The torcheval 0.0.6 lib depends on a torchtnt>=0.0.5, however the available versions
  # of torchtnt on nixpkgs (0.4.2 at the time of writing) are not compatible due to missing methods.
  #
  # To remedy this, the torchtnt-nightly commit on Github that was published on the same day as
  # the torcheval 0.0.6 lib is used in lieu of a properly packaged torchtnt lib,
  # as it is doubtful that this particular release of torchtnt is useful outside of this package.
  torchtnt = callPackage ./torchtnt-nightly.nix { };
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

  # Patches are only applied to calls of sklearn within tests,
  # which is only used for testing purposes (see dev-requirements.txt)
  patches = [
    # sklearn's confusion matrix's `normalize` keyword argument does not support "none".
    # However, None and "none" appear twice in this test; The only missing case is "all".
    ./0001-sklearn-cm-normalize.patch

    # sklearn's mean squared error requires naming `sample_weight` due to the asterisk in
    # mean_squared_error(y_true, y_pred, *, sample_weight=None, ...)
    #                                   ^^^
    ./0002-sklearn-mse-sample-weight.patch
  ];

  buildInputs = [ setuptools ];

  pythonImportsCheck = [ "torcheval" ];

  # requirements.txt
  dependencies = [
    torchtnt
    typing-extensions
  ];

  # dev-requirements.txt
  nativeCheckInputs = [
    pytestCheckHook
    numpy
    torchvision
    pytest-timeout
    cython_0
    scikit-learn
  ];

  pytestFlagsArray = [
    "tests/"
  ];

  meta = {
    description = "Rich collection of performant PyTorch model metrics, a simple interface to create new metrics, a toolkit to facilitate metric computation in distributed training and tools for PyTorch model evaluations";
    homepage = "https://pytorch.org/torcheval";
    changelog = "https://github.com/pytorch/torcheval/releases/tag/${version}";

    platforms = lib.platforms.linux;

    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ bengsparks ];
  };
}
