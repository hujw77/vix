{ config, pkgs, lib, ... }: {
  options = with lib; {
    pkgSets = mkOption {
      type = types.attrsOf (types.listOf types.package);
      default = { };
      description = "Package sets";
    };
  };

  config = {

    pkgSets = with pkgs; {
      # System level packages
      vico = [
        nixFlakes
        direnv
        home-manager
      ];

      # Home level packages
      echo = [
        VimMotionApp
        bottom
        xsv
        htop
        gitui
        xh # fetch things
        bat # better cat
        jump
        rbenv
        # browsh # Firefox on shell
        exa # alias ls
        fd # alias find
        fzf # ctrl+r history
        # git-lfs # large binary files in git
        ripgrep # grep faster
        # ripgrep-all # rg faster grep on many file types
        tig # terminal git ui
        # victor-mono # fontz ligatures
        # tor-browser # darkz web
        # firefox-developer # firefox with dev nicities
        # iterm2 # terminal
        # flux # late programming
        # pock # make touchbar useful
        # keybase # secure comms

        shfmt
        shellcheck

        niv # manage nix dependencies
        nixfmt # fmt nix sources
        nox # quick installer for nix
        nix-prefetch

        git
        gh
        jq # query json
      ];

    };

    nixpkgs.overlays = [
      (new: old: {
        pkgShells =
          lib.mapAttrs (name: packages: old.mkShell { inherit name packages; })
          config.pkgSets;

        pkgSets =
          lib.mapAttrs (name: paths: old.buildEnv { inherit name paths; })
          config.pkgSets;
      })
    ];
  };
}
