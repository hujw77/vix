# ####
## > env NIX_CONF_DIR="$PWD" nix run
{
  description = "Echo's Nix Environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/21.11";
    # mk-darwin-system.url = "github:hujw77/mk-darwin-system";
    mk-darwin-system.url = "/Users/echo/workspace/tools/mk-darwin-system";
    mk-darwin-system.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, mk-darwin-system, ... }:
    let
      darwinFlakeOutput = mk-darwin-system.mkDarwinSystem.m1 {
        modules = [
          ({ pkgs, lib, ... }: {
            config._module.args = {
              vix = self // {
                lib = import ./vix/lib {
                  vix = self;
                  inherit pkgs lib;
                };
              };
            };
          })

          ./vix/modules
        ];
      };
    in darwinFlakeOutput // {
      nixosConfigurations."vico" =
        darwinFlakeOutput.nixosConfiguration.x86_64-darwin;
    };
}
