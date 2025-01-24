{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils = { url = "github:numtide/flake-utils"; };
  };

  outputs = { nixpkgs, nixpkgs-unstable, flake-utils, ... }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs-unstable {
        inherit system;
      #   overlays = [(self: super: rec {
      #     python3 = super.python3.override {
      #       packageOverrides = pyself: pysuper: {
      #         torchtnt = nixpkgs-unstable.legacyPackages.${system}.python3Packages.torchtnt;
      #       };
      #     };

      #     python3Packages = python3.pkgs;
      #   })];
      };

      # torchtnt-nightly = pkgs.python3Packages.callPackage ./torchtnt-nightly.nix { };
      torcheval = pkgs.python3Packages.callPackage ./. { };
    in
    {
      packages = {
        inherit torcheval;# torchtnt-nightly;
        default = torcheval;
      };
      devShells.default = pkgs.callPackage ./shell.nix {  };
    });
}
