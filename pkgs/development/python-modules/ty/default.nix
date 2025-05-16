{
  lib,
  ty,
  buildPythonPackage,
  rustPlatform,
  installShellFiles,
  versionCheckHook,
}:

buildPythonPackage {
  inherit (ty)
    pname
    version
    src
    cargoRoot
    cargoDeps
    postInstall
    versionCheckProgramArg
    meta
    ;

  postPatch = ''
    substituteInPlace python/ty/__main__.py --replace-fail \
      '"""Return the ty binary path."""' 'return "${lib.getExe ty}"'
  '';

  nativeBuildInputs = [
    installShellFiles
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  # Check the version of the packaged `ty` binary
  nativeCheckInputs = [ versionCheckHook ];

  pyproject = true;
  pythonImportsCheck = [ "ty" ];
}
