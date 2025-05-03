{
  lib,
  rustPlatform,
  ruff,

  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "red_knot";
  version = "0.0.0";

  inherit (ruff) src useFetchCargoVendor cargoDeps buildInputs doCheck;

  cargoBuildFlags = [
    "--package"
    "red_knot"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    description = "Extremely fast type checker for Python";
    inherit (ruff.meta) homepage changelog license;
    mainProgram = "red-knot";
    maintainers = [ lib.maintainers.bengsparks ];
  };
})