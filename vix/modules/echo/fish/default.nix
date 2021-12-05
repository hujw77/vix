{ config, lib, pkgs, vix, USER, DOTS, ... }: {

  home-manager.users.${USER} = {

    programs.fzf.enable = true;
    programs.fzf.enableFishIntegration = true;

    programs.fish = {
      enable = true;

      shellAliases = {
        vi = "nvim";
        vim = "nvim";
        e = "emacsclient -t";

        l = "exa -l";
        ll = "exa -l -@ --git";
        tree = "exa -T";
        # "." = "exa -g";
        ".." = "cd ..";
      };

      shellAbbrs = {
        ls = "exa";
        top = "btm";
        cat = "bat";
        grep = "rg";
        find = "fd";
        nr = "nix run";
        nf = "fd --glob '*.nix' -X nixfmt {}";
        gc = "git commit";
        gb = "git branch";
        gd = "git diff";
        gs = "git status";
        gco = "git checkout";
        gcb = "git checkout -b";
        gp = "git pull --rebase --no-commit";
        gz = "git stash";
        gza = "git stash apply";
        gfp = "git push --force-with-lease";
        gfap = "git fetch --all -p";
        groh = "git rebase remotes/origin/HEAD";
        grih = "git rebase -i remotes/origin/HEAD";
        grom = "git rebase remotes/origin/master";
        grim = "git rebase -i remotes/origin/master";
        gpfh = "git push --force-with-lease origin HEAD";
        gfix = "git commit --all --fixup amend:HEAD";
        gcm = "git commit --all --message";
        gcaa = "git commit --amend --all --reuse-message HEAD";
        gcam = "git commit --amend --all --message";
        gbDm =
          "git for-each-ref --format '%(refname:short)' refs/heads | grep -v master | xargs git branch -D";

        # Magit
        # ms = "spc g g"; # status
        # mc = "spc g / c"; # commit
        # md = "spc g / d u"; # diff unstaged
        # ml = "spc g / l l"; # log
        # mr = "spc g / r i"; # rebase interactive
        # mz = "spc g / Z l"; # list stash
      };

      shellInit = ''
        set fish_greeting ""
      '';

      loginShellInit = ''
        set -x PATH /nix/var/nix/profiles/default/bin $PATH
        set -x PATH /etc/profiles/per-user/${USER}/bin $PATH

        set -gx LC_ALL en_US.UTF-8
        set -gx LANG en_US.UTF-8

        set -gx LSCOLORS cxBxhxDxfxhxhxhxhxcxcx
        set -gx CLICOLOR 1
      '';

      interactiveShellInit = ''
        # set -g fish_key_bindings fish_hybrid_key_bindings
        set -U fish_color_normal normal
        set -U fish_color_quote a3be8c
        set -U fish_color_command 81a1c1
        set -U fish_color_error ebcb8b
        set -U fish_color_end 88c0d0
        set -U fish_color_redirection b48ead
        set -U fish_color_param eceff4
        set -U fish_color_comment 434c5e
        set -U fish_color_match --background=brblue
        set -U fish_color_selection white --bold --background=brblack
        set -U fish_color_search_match bryellow --background=brblack
        set -U fish_color_history_current --bold
        set -U fish_color_operator 00a6b2
        set -U fish_color_escape 00a6b2
        set -U fish_color_cwd green
        set -U fish_color_cwd_root red
        set -U fish_color_valid_path --underline
        set -U fish_color_autosuggestion 4c566a
        set -U fish_color_user brgreen
        set -U fish_color_host normal
        set -U fish_color_cancel -r
        set -U fish_pager_color_completion normal
        set -U fish_pager_color_description B3A06D yellow
        set -U fish_pager_color_prefix normal --bold --underline
        set -U fish_pager_color_progress brwhite --background=cyan

        set -gx FZF_DEFAULT_OPTS $FZF_DEFAULT_OPTS '
            --color=fg:#e5e9f0,bg:#3b4252,hl:#81a1c1
            --color=fg+:#e5e9f0,bg+:#3b4252,hl+:#81a1c1
            --color=info:#eacb8a,prompt:#bf6069,pointer:#b48dac
            --color=marker:#a3be8b,spinner:#b48dac,header:#a3be8b'

        status --is-interactive; and source (jump shell fish | psub)

        # rbenv
        status --is-interactive; and source (rbenv init -|psub)
      '';

      functions = {
        # spc.body = "espace $argv -- -nw";
        # vspc.body = "espace $argv -- -c";
        fish_prompt = ''
          set -g __fish_git_prompt_show_informative_status 1
          set -g __fish_git_prompt_showdirtystate 'yes'
          set -g __fish_git_prompt_char_stateseparator ' '
          set -g __fish_git_prompt_char_dirtystate "✖"
          set -g __fish_git_prompt_char_cleanstate "✔"
          set -g __fish_git_prompt_char_untrackedfiles "…"
          set -g __fish_git_prompt_char_stagedstate "●"
          set -g __fish_git_prompt_char_conflictedstate "+"
          set -g __fish_git_prompt_color_dirtystate yellow
          set -g __fish_git_prompt_color_cleanstate green --bold
          set -g __fish_git_prompt_color_invalidstate red
          set -g __fish_git_prompt_color_branch cyan --dim --italics

          echo -n -s (set_color $fish_color_cwd --bold) (prompt_pwd)(set_color normal) (fish_git_prompt) " "
        '';

        b.description = "Fuzzy-find and checkout a branch";
        b.body = ''
          git branch | grep -v HEAD | string trim | fzf | read -l result; and git checkout "$result"
        '';
        bt.wraps = "go build ./... && go test ./...";
        bt.description = "alias bt=go build ./... && go test ./...";
        bt.body = "go build ./... && go test ./... $argv";

        c.body = ''
          set -l dirs ~/{workspace/*,workspace/contract/evolutionlandorg/*,workspace/contract/darwinia/*}
          set -l directory (command ls -d -1 $dirs 2>/dev/null | fzf --tiebreak=length,begin,end)
          if test -n "$directory"
              and test -d $directory
              cd $directory
          end
        '';

        cat.wraps = "bat";
        cat.description = "alias cat=bat";
        cat.body = "bat -p $argv";

        cdr.wraps = "cd (git rev-parse --show-toplevel)";
        cdr.description = "alias cdr=cd (git rev-parse --show-toplevel)";
        cdr.body = "cd (git rev-parse --show-toplevel) $argv";

        co.wraps = "git checkout (basename (git symbolic-ref refs/remotes/origin/HEAD))";
        co.description = "alias co=git checkout (basename (git symbolic-ref refs/remotes/origin/HEAD))";
        co.body = "git checkout (basename (git symbolic-ref refs/remotes/origin/HEAD)) $argv";

        fish_hybrid_key_bindings.description =
          "Vi-style bindings that inherit emacs-style bindings in all modes";
        fish_hybrid_key_bindings.body = ''
          for mode in default insert visual
              fish_default_key_bindings -M $mode
          end
          fish_vi_key_bindings --no-erase
        '';

        fish_user_key_bindings.body = "fzf_key_bindings";

        ghdel.body = ''
          co
          for i in (git branch | grep hujw77);
            git br -D (string trim $i)
          end
        '';

        ghpr.body = ''
          git push -u origin
          gh pr create --web --fill
        '';

        git_branch_name.body = ''
          set -l dir $PWD/
          while test -n "$dir"
            set dir (string split -r -m1 / $dir)[1]
            if test -f "$dir/.git/HEAD"; and read -l git_head <"$dir/.git/HEAD"
              if set -l branch_name (string match -r '^ref: refs/heads/(.+)|([0-9a-f]{7})[0-9a-f]+$' $git_head)
                echo $branch_name[2]
              end
              return
            end
          end
        '';

        hb.wraps = "gh repo view --web";
        hb.description = "alias hb=gh repo view --web";
        hb.body = "gh repo view --web $argv";

        hc.wraps = "gh pr view --web";
        hc.description = "alias hc=gh pr view --web";
        hc.body = "gh pr view --web $argv";

        icloud.wraps = "cd\ \~/Library/Mobile\\\ Documents/com\~apple\~CloudDocs/";
        icloud.description = "alias\ icloud=cd\ \~/Library/Mobile\\\ Documents/com\~apple\~CloudDocs/";
        icloud.body = "cd ~/Library/Mobile\ Documents/com~apple~CloudDocs/ $argv";

        noproxy.description = "Clear all proxy environment variables";
        noproxy.body = ''
          set -eg http_proxy
          set -eg HTTP_PROXY
          set -eg https_proxy
          set -eg HTTPS_PROXY
          git config --global --unset http.proxy
          git config --global --unset http.sslVerify
          git config --global --unset https.proxy
        '';

        proxy.description = "Setup proxy environment variables";
        proxy.body = ''
          set -gx http_proxy http://127.0.0.1:1087
          set -gx HTTP_PROXY http://127.0.0.1:1087
          set -gx https_proxy http://127.0.0.1:1087
          set -gx HTTPS_PROXY http://127.0.0.1:1087
          git config --global http.proxy 'socks5://127.0.0.1:1081'
          git config --global http.sslVerify false
          git config --global https.proxy 'socks5://127.0.0.1:1081'
        '';

        po.wraps = "git pull origin (git rev-parse --abbrev-ref HEAD)";
        po.description = "alias po=git pull origin (git rev-parse --abbrev-ref HEAD)";
        po.body = "git pull origin (git rev-parse --abbrev-ref HEAD) $argv";

        pushtag.argumentNames = [ "ver" "comment" ];
        pushtag.body = ''
          if test -z "$ver"
            echo "Usage: pushtag [version] [comment]"
            return
          end

          if test -z "$comment"
            echo "Usage: pushtag [version] [comment]"
            return
          end

          co
          po

          git tag -a $ver -m $comment
          git push origin $ver
        '';

        sq.wraps = "git rebase -i (git merge-base (git rev-parse --abbrev-ref HEAD) (basename (git symbolic-ref refs/remotes/origin/HEAD)))";
        sq.description = "alias sq=git rebase -i (git merge-base (git rev-parse --abbrev-ref HEAD) (basename (git symbolic-ref refs/remotes/origin/HEAD)))";
        sq.body = "git rebase -i (git merge-base (git rev-parse --abbrev-ref HEAD) (basename (git symbolic-ref refs/remotes/origin/HEAD))) $argv";

        tigs.wraps = "tig status";
        tigs.description = "alias tigs=tig status";
        tigs.body = "tig status $argv";

        vix-activate.description = "Activate a new vix system generation";
        vix-activate.body = "nix run /hk/vix";

        vix-nixpkg-search.description = "Nix search on vix's nixpkgs input";
        vix-nixpkg-search.body =
          "nix search --inputs-from $HOME/.nix-out/vix nixpkgs $argv";

        rg-vix-inputs.description = "Search on vix flake inputs";
        rg-vix-inputs.body = let
          flakePaths = flake:
            [ flake.outPath ]
            ++ lib.flatten (lib.mapAttrsToList (_: flakePaths) flake.inputs);

          paths = builtins.concatStringsSep " " (flakePaths vix);
        in "rg $argv ${paths}";

        rg-vix.description = "Search on current vix";
        rg-vix.body = "rg $argv $HOME/.nix-out/vix";

        rg-nixpkgs.description = "Search on current nixpkgs";
        rg-nixpkgs.body = "rg $argv $HOME/.nix-out/nixpkgs";

        rg-home-manager.description = "Search on current home-manager";
        rg-home-manager.body = "rg $argv $HOME/.nix-out/home-manager";

        rg-nix-darwin.description = "Search on current nix-darwin";
        rg-nix-darwin.body = "rg $argv $HOME/.nix-out/nix-darwin";

        nixos-opt.description =
          "Open a browser on search.nixos.org for options";
        nixos-opt.body = ''
          open "https://search.nixos.org/options?sort=relevance&query=$argv"'';

        nixos-pkg.description =
          "Open a browser on search.nixos.org for packages";
        nixos-pkg.body = ''
          open "https://search.nixos.org/packages?sort=relevance&query=$argv"'';

        repology-nixpkgs.description =
          "Open a browser on search for nixpkgs on repology.org";
        repology-nixpkgs.body = ''
          open "https://repology.org/projects/?inrepo=nix_unstable&search=$argv"'';
      };

      plugins =
        # map vix.lib.nivFishPlugin [ "pure" "done" "fzf.fish" "pisces" "z" ];
        map vix.lib.nivFishPlugin [ "fzf.fish" ];
    };

    home.file = {
      ".local/share/fish/fish_history".source = "${DOTS}/fish/fish_history";
    };

  };

}
