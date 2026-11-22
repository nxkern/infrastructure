{
  description = "Infraestructure";

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
        lock = pkgs.writeShellScriptBin "lock" ''
          exec env NIXPKGS_ALLOW_UNFREE=1 nix shell --impure nixpkgs#terraform -c terraform providers lock \
            -platform=linux_amd64 \
            -platform=linux_arm64 \
            -platform=darwin_amd64 \
            -platform=darwin_arm64 \
            -platform=windows_amd64 "$@"
        '';
        packages = [
          lock
          pkgs.docker-buildx
          pkgs.azure-cli
          pkgs.lefthook
          pkgs.terraform-ls
          (pkgs.terraform.withPlugins (p: [
            p.kreuzwerker_docker
            tf-providers.aztfmod.azurecaf
            tf-providers.cloudflare.cloudflare
            p.hashicorp_null
            p.hashicorp_azurerm
          ]))
        ];
      in
      {
        devShells.default = pkgs.mkShell {
          inherit packages;
          shellHook = ''
            lefthook install
            echo -e "\033[1;32m✔ Infraestructure environment active.\033[0m"
          '';
        };

      }
    );
}
