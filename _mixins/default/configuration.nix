{
  config,
  lib,
  pkgs,
  ...
}: let
  username = config.mixins.default.username;
in {
  options.mixins.default = {
    username = lib.mkOption {
      type = lib.types.str;
    };
  };

  config = {
    system.stateVersion = "23.05";

    # Define a user account
    users.users.${username} = {
      description = "Hannes";
      isNormalUser = true;
      extraGroups = ["wheel" "network"];
      openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFLnJfxLDy7PgM2UJUk2H0TkwTqSuOGUJE9zoGmi8LOm"];
    };

    # Allow wheel group to use sudo without a password
    security.sudo.wheelNeedsPassword = false;

    # Enable automatic Nix garbage collection
    nix.gc = {
      automatic = true;
      options = "--delete-older-than=1d";
    };

    # Set locale
    i18n = {
      defaultLocale = "en_GB.UTF-8";
    };

    # Set the time zone
    time.timeZone = "Asia/Taipei";

    # Home manager
    home-manager = {
      useGlobalPkgs = true;
      backupFileExtension = ".home-manager-backup";
      useUserPackages = true;

      users.${username} = {
        # Read the changelog before changing this value
        home.stateVersion = "23.05";

        # Enable home-manager
        programs.home-manager.enable = true;

        # Nix
        nix.settings = {
          auto-optimise-store = true;
          experimental-features = ["nix-command" "flakes"];
          use-xdg-base-directories = true;
        };

        home.packages =
          # System packages
          (
            with pkgs; [
              hostname
              nano
              tzdata
            ]
          )
          ++
          # XDG integration
          (
            with pkgs; [
              xdg-user-dirs
              xdg-utils
            ]
          );

        # Manpages
        programs.man = {
          enable = true;
          generateCaches = true;
        };

        # Topgrade
        programs.topgrade = {
          enable = true;
          settings = {
            misc = {
              assume_yes = true;
              disable = [
                # "containers"
                # "distrobox"
                # "flutter"
                # "github_cli_extensions"
                # "guix"
                # "node"
                # "pip3"
                # "snap"
              ];
            };
          };
        };

        # Tealdeer
        programs.tealdeer = {
          enable = true;
          settings = {
            updates.auto_update = true;
          };
        };
      };
    };
  };
}
