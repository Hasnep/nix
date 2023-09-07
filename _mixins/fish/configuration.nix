{
  pkgs,
  config,
  lib,
  ...
}: let
  username = config.mixins.default.username;
in {
  options.mixins.fish = {
    enable = lib.mkEnableOption (lib.mdDoc "fish");
    lsd.enable = lib.mkEnableOption (lib.mdDoc "lsd");
    fzf.enable = lib.mkEnableOption (lib.mdDoc "fzf");
    bat.enable = lib.mkEnableOption (lib.mdDoc "bat");
    trashy.enable = lib.mkEnableOption (lib.mdDoc "trashy");
  };

  config = {
    # Enable fish
    programs.fish.enable = config.mixins.fish.enable;

    # Set fish as the default shell
    users.users.hannes.shell = lib.mkIf config.mixins.fish.enable pkgs.fish;

    home-manager.users.${username} = {
      programs.fish = {
        enable = config.mixins.fish.enable;

        shellAbbrs = {
          rip = lib.mkIf config.mixins.fish.trashy.enable "trash put";
        };

        # Add plugins
        plugins =
          [
            {
              name = "done";
              src = pkgs.fishPlugins.done.src;
            }
          ]
          ++ (
            if config.mixins.fish.fzf.enable
            then [
              {
                name = "fzf-fish";
                src = pkgs.fishPlugins.fzf-fish.src;
              }
            ]
            else []
          );

        # Add custom functions
        functions = {
          # Custom prompt
          fish_prompt = {body = lib.strings.fileContents ./fish_prompt.fish;};

          # Custom greeting
          fish_greeting = {body = lib.strings.fileContents ./fish_greeting.fish;};

          # Ls wrappers
          ls = lib.mkIf config.mixins.fish.lsd.enable {
            wraps = "lsd";
            body = "command lsd --group-dirs=first --git --icon-theme=unicode $argv";
          };

          la =
            if config.mixins.fish.lsd.enable
            then {
              wraps = "lsd";
              body = "command lsd --group-dirs=first --git --icon-theme=unicode --long --all $argv";
            }
            else {
              wraps = "ls";
              body = "command ls -l --all";
            };

          tree = lib.mkIf config.mixins.fish.lsd.enable {
            wraps = "lsd";
            body = "lsd --group-dirs=first --git --icon-theme=unicode --tree $argv";
          };

          fishes = ''
            while true
                # Fish
                echo -n \U1F41F
                # Water
                for i in (seq (random 0 100))
                    echo -n " "
                end
            end
          '';

          please = {
            wraps = "sudo";
            body = "command sudo $argv";
          };

          lock = {
            wraps = "xdg-screensaver";
            body = "command xdg-screensaver lock $argv";
          };
        };
      };

      # Bat
      programs.bat.enable = config.mixins.fish.bat.enable;

      # Fzf
      programs.fzf = {
        enable = config.mixins.fish.fzf.enable;
        enableFishIntegration = false;
        colors = {
          "bg" = "#1e1e1e";
          "bg+" = "#1e1e1e";
          "fg" = "#d4d4d4";
          "fg+" = "#d4d4d4";
        };
        defaultCommand = "fd --type f";
        historyWidgetOptions = ["--sort" "--exact"];
        changeDirWidgetCommand = "fd --type d";
        changeDirWidgetOptions = ["--preview 'tree -C {} | head -200'"];
        fileWidgetCommand = "fd --type f";
        fileWidgetOptions = ["--preview 'head {}'"];
      };

      home.packages = with pkgs; [
        # Lsd
        (lib.mkIf (config.mixins.fish.enable && config.mixins.fish.lsd.enable) lsd)
        # Trashy
        (lib.mkIf (config.mixins.fish.enable && config.mixins.fish.trashy.enable) trashy)
        # Onefetch
        (lib.mkIf (config.mixins.fish.enable && config.mixins.git.enable) onefetch)
        # Tree
        (lib.mkIf (!config.mixins.fish.lsd.enable) tree)
      ];
    };
  };
}
