{
  # Python package building
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  # meta
  lib,
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

  meta = {
    description = "Rich collection of performant PyTorch model metrics, a simple interface to create new metrics, a toolkit to facilitate metric computation in distributed training and tools for PyTorch model evaluations";
    homepage = "https://pytorch.org/torcheval";
    changelog = "https://github.com/pytorch/torcheval/releases/tag/${version}";

    platforms = lib.platforms.linux;

    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ bengsparks ];
  };
}
