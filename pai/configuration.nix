{
  config,
  pkgs,
  ...
}: let
  username = config.mixins.default.username;
in {
  options = {};

  config = {
    mixins = {
      default = {username = "hannes";};
      # disk = {name = "mmcblk0";};
      network = {hostName = "pai";};
      editors = {
        micro.enable = true;
        helix.enable = false;
        defaultEditor = "micro";
      };
      fish = {
        enable = true;
        fzf.enable = true;
        lsd.enable = true;
        bat.enable = true;
        trashy.enable = true;
      };
      git = {
        enable = true;
        name = "Hannes";
        email = "h@nnes.dev";
      };
      # pcloud = {
      #   enable = true;
      # };
      # jellyfin = {
      #   enable = true;
      #   bare-metal.enable = true;
      #   containerised.enable = false;
      # };
    };

    fileSystems."/mnt/caddy" = {
      device = "/dev/disk/by-label/caddy";
      fsType = "ext4";
      options = [
        "nofail" # Don't fail boot if can't mount
        # "defaults"
        # "dmask=007"
        # "fmask=117"
        # "gid=1"
        # "uid=1001"
        # "umask=000"
        "rw"
        # "user"
        # "utf8"
      ];
    };

    boot.loader = {
      # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
      grub.enable = false;
      # Enables the generation of /boot/extlinux/extlinux.conf
      generic-extlinux-compatible.enable = true;
    };

    # # Webdav2
    # services.davfs2 = {
    #   enable = true;
    #   davUser = "hannes";
    #   davGroup = "wheel";
    # };
    # environment.etc = {
    #   "davfs2/secrets" = {
    #     text = "https://ewebdav.pcloud.com:443 h@nnes.dev ftLyG5h0pcloud";
    #     mode = "600";
    #   };
    # };
    # services.autofs = {
    #   enable = true;
    #   autoMaster = let
    #     mapConfFile = pkgs.writeText "auto" "pcloud -fstype=davfs,ro :https\://ewebdav.pcloud.com\:443";
    #     mountPoint = "/home/hannes/pcloud";
    #   in "${mountPoint} file:${mapConfFile}";
    # };

    # Home manager
    home-manager.users.${username} = {
      # Zellij
      programs.zellij = {
        enable = true;
        # Automatically launches Zellij on login when enabled
        enableFishIntegration = false;
      };

      # Btop
      programs.btop.enable = true;

      # Htop
      programs.htop.enable = true;

      # Jq
      programs.jq.enable = true;

      # # Ripgrep
      # programs.ripgrep.enable = true; # Only in home-manager-unstable at the moment

      # User packages
      home.packages = with pkgs; (
        builtins.concatLists (
          builtins.attrValues {
            clis = [
              httpie
              fd
              f2
              ripgrep
              jc
              macchina
              jello
              lolcat
              mosh
              # bfs
              # ffmpeg
              # glow
              # graphviz
              # hyperfine
              # imagemagick
              # magic-wormhole
              # moreutils
              # mpv
              # neofetch
              # onefetch
              # potrace
              # rclone
              # sd

              # wget
              # yq
            ];
            tui = [
              # lynx
              # orpie # RPN calculator
              # tmux
              # visidata
            ];
            compression = [
              # gnutar
              # unzip
              # zip
            ];
            common-tools = [
              curl
              diffutils
              findutils
              gnugrep
              gnused
              hostname
              nano
              tzdata
              utillinux
            ];
          }
        )
      );
    };
  };
}
