{ config, lib, pkgs, USER, DOTS, ... }: {
  home-manager.users.${USER} = {

    programs.git = {
      enable = true;
      userName = "echo";
      userEmail = "hujw77@gmail.com";

      extraConfig = {
        init = { defaultBranch = "main"; };
      };

      aliases = {
        "fap" = "fetch --all -p";
	"st" = "status -sb"
	"ci" = "commit"
	"reci" = "commit --amend"
	"all" = "commit -am"
	"br" = "branch"
	"co" = "checkout"
	"di" = "diff"
	"dic" = "diff --cached"
	"lg" = "log -p"
	"lol" = "log --graph --decorate --pretty=oneline --abbrev-commit"
	"lola" = "log --graph --decorate --pretty=oneline --abbrev-commit --all"
	"ls" = "ls-files"
	# Show files ignored by git:
	"ign" = "ls-files -o -i --exclude-standard"

	"shoot" = "push origin --delete"
	"unstage" = "reset HEAD --"
	"prev" = "checkout -"
	"discard" = "checkout --"
      };

      ignores = [ ".DS_Store" "*.swp" ];

      includes = [ ]; # { path = "${DOTS}/git/something"; }

      lfs.enable = true;
      delta.enable = true;
      delta.options = {
        line-numbers = true;
        side-by-side = true;
      };
    };

  };

}
