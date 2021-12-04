{ lib, pkgs, vix, ... }: rec {

  nivSources = import "${vix}/nix/sources.nix";

  vixLink = path: lib.mkOutOfStoreSymlink "/hk/vix/${path}";

  nivApp = name:
    lib.mds.installNivDmg {
      inherit name;
      src = nivSources."${name}App";
    };
}
