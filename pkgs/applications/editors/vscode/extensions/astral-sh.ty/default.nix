{
  lib,
  jq,
  ty,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "ty";
    publisher = "astral-sh";
    version = "2025.5.11331618";
    hash = "sha256-rb4PgKz+DHabjgMJYRW3Bvv+cRhCR9o1VElWDd/86pg=";
  };

  nativeBuildInputs = [ jq ];

  postInstall = ''
    test -x "$out/$installPrefix/bundled/libs/bin/ty" || {
      echo "Replacing the bundled `ty` binary failed, because 'bundled/libs/bin/ty' is missing."
      echo "Update the package to the match the new path/behavior."
      exit 1
    }
    ln -sf ${lib.getExe ty} "$out/$installPrefix/bundled/libs/bin/ty"
  '';

  meta = {
    description = "Support for the ty type checker and language server.";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=astral-sh.ty";
    changelog = "https://marketplace.visualstudio.com/items/astral-sh.ty/changelog";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.bengsparks ];
  };
}
