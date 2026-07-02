{
  lib,
  makeSetupHook,
  python3Packages,
  yq,
}:
makeSetupHook {
  name = "uv-build-version-substitute-hook";
  substitutions = {
    tomlq = lib.getExe' yq "tomlq";
    filter = builtins.readFile ./filter.jq;
  };
  propagatedBuildInputs = [ yq ];
  meta = {
    description = "Replace the version constraints of uv-build";
    inherit (python3Packages.uv-build.meta) maintainers;
    license = lib.licenses.mit;
  };
} ./hook.sh

