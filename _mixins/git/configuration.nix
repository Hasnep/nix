{
  config,
  pkgs,
  lib,
  ...
}: let
  username = config.mixins.default.username;
in {
  options.mixins.git = {
    enable = lib.mkEnableOption (lib.mdDoc "git");
    name = lib.mkOption {
      type = lib.types.str;
      default = "Hannes";
    };
    email = lib.mkOption {
      type = lib.types.str;
    };
    delta.enable = lib.mkEnableOption (lib.mdDoc "delta");
  };

  config = {
    home-manager.users.${username} = {
      # Git CLI
      programs.git = {
        enable = config.mixins.git.enable;
        # Add git alias for making WIP commits
        aliases = {
          wip = "!git commit -m WIP";
        };
        # Use delta as git's diff tool
        delta.enable = config.mixins.git.delta.enable;
        # Set the default git branch name to "main"
        extraConfig = {
          init = {defaultBranch = "main";};
        };
        ignores = [
          # MacOS metadata
          ".DS_Store"
          # VSCode files
          ".vscode/"
        ];
        userName = config.mixins.git.name;
        userEmail = config.mixins.git.email;
      };

      # GitHub CLI
      programs.gh = {
        enable = config.mixins.git.enable;
        settings = {git_protocol = "ssh";};
      };

      # Jujutsu
      programs.jujutsu = {
        enable = config.mixins.git.enable;
        enableFishIntegration = false; # Completions not working at the moment
        settings = {
          user = {
            name = config.mixins.git.name;
            email = config.mixins.git.email;
          };
        };
      };

      # Delta
      home.packages = lib.mkIf config.mixins.git.delta.enable (with pkgs; [delta]);
    };
  };
}
