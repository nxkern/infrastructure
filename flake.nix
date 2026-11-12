{
  description = "homelab_infraestructure";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs-terraform-providers-bin.url = "github:nix-community/nixpkgs-terraform-providers-bin";
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      nixpkgs-terraform-providers-bin,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        tf-providers = nixpkgs-terraform-providers-bin.legacyPackages.${system}.providers;

        packages = [
          (pkgs.terraform.withPlugins (p: [
            p.kreuzwerker_docker
            tf-providers.aztfmod.azurecaf
          ]))
        ];
      in
      {
        devShells.default = pkgs.mkShell { inherit packages; };

      }
    );
}
