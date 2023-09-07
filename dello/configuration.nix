{
  config,
  pkgs,
  ...
}: let
  username = config.mixins.default.username;
in {
  options = {};

  config = {
    # Network
    mixins = {
      default = {username = "hannes";};
      network = {hostName = "dello";};
      editors = {
        micro.enable = true;
        helix.enable = true;
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
      gui = {enable = true;};
      pipewire = {enable = true;};
      xfce = {enable = true;};
    };

    # Home manager
    home-manager.users.${username} = {
      # Nushell
      programs.nushell.enable = true;

      # Zellij
      programs.zellij.enable = true;

      # Bat
      programs.bat.enable = true;

      # Btop
      programs.btop.enable = true;

      # Htop
      programs.htop.enable = true;

      # Jq
      programs.jq.enable = true;

      # # Ripgrep
      # programs.ripgrep.enable = true; # Only in home-manager-unstable at the moment

      # Skim
      programs.skim = {
        enable = true;
        enableFishIntegration = false;
        changeDirWidgetCommand = "fd --type d";
        changeDirWidgetOptions = ["--preview 'tree -C {} | head -200'"];
        defaultCommand = "fd --type f";
        fileWidgetCommand = "fd --type f";
        fileWidgetOptions = ["--preview 'head {}'"];
        historyWidgetOptions = ["--sort" "--exact"];
      };

      # User packages
      home.packages = with pkgs; (
        builtins.concatLists (
          builtins.attrValues {
            clis = [
              czkawka
              # distrobox
              bfs
              curlie
              delta
              dua
              entr
              f2
              fd
              ffmpeg
              glow
              graphviz
              grex
              gron
              httpie
              hyperfine
              imagemagick
              imgcat
              jc
              # jello # not in nixpkgs-23.05
              lolcat
              macchina
              magic-wormhole
              moreutils
              mosh
              mpv
              neofetch
              onefetch
              potrace
              rclone
              restic
              sd
              simple-http-server
              tesseract
              tokei
              wget
              xdg-ninja
              yq
            ];
            git = [
              git-delete-merged-branches
              git-machete
              git-revise
            ];
            nickel = [
              nls # Nickel language server
              nickel
            ];
            build-tools = [
              gnumake
              just
              meson
              ninja
              samurai
              tup
            ];
            dev = [
              crystal
              deno
              duckdb
              godot_4
              hugo
              julia-bin
              latex2mathml
              linode-cli
              netlify-cli
              nim
              nodePackages.prettier
              orogene
              pre-commit
              R
              shellcheck
              tectonic
              topiary
              yamllint
            ];
            typst = [
              typst
              typst-fmt
              # typst-live # not in nixpkgs-23.05
              typst-lsp
            ];
            zig = [
              zig
              zls # Zig language server
            ];
            # janet = [
            #   janet
            #   jpm
            # ];
            nix = [
              alejandra # Nix formatter
              nil # Nix language server
            ];
            tui = [
              lynx
              orpie # RPN calculator
              tmux
              visidata
            ];
            python = [
              black
              isort
              poetry
              poetryPlugins.poetry-audit-plugin
              # poetryPlugins.poetry-plugin-export # not in nixpkgs-23.05
              poetryPlugins.poetry-plugin-up
              nodePackages.pyright
              python3
              ruff
            ];
            compression = [
              gnutar
              unzip
              zip
            ];
            common-tools = [
              bc
              curl
              diffutils
              findutils
              gnugrep
              gnused

              utillinux
            ];
          }
        )
      );

      # # Email
      # accounts.email.accounts.primary = {
      #   primary = true;
      #   realName = name;
      #   address = email;
      #   # thunderbird.enable = true;
      #   userName = email;
      #   imap = {
      #     host = "mail.hover.com";
      #     port = 143;
      #     tls = {
      #       enable = true;
      #       useStartTls = true;
      #     };
      #   };
      # };

      # # Add to the PATH
      # home.sessionPath = [];

      # Go
      programs.go.enable = true;

      # Pandoc
      programs.pandoc = {
        enable = true;
        defaults = {
          pdf-engine = "tectonic";
        };
      };

      # Yt-dlp
      programs.yt-dlp.enable = true;
    };
  };
}
