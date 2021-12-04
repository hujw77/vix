{ config, pkgs, lib, vix, vix-lib, ... }: {

  system.stateVersion = 4;

  nix.extraOptions = builtins.readFile "${vix}/nix.conf";

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  environment.systemPackages = config.pkgSets.vico;

  services.nix-daemon.enable = true;
  services.lorri.enable = true;
}
