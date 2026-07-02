uvBuildVersionSubstituteHook() {
  echo "Executing uvBuildVersionSubstituteHook"
  @tomlq@ --toml-output --in-place '@filter@' pyproject.toml
}

if [[ -z "${dontSubstituteUvBuildVersion-}" ]]; then
  echo "Using uvBuildVersionSubstituteHook"
  postPatchHooks+=(uvBuildVersionSubstituteHook)
fi
