{
  config,
  pkgs,
  lib,
  ...
}: let
  username = config.mixins.default.username;
in {
  options.mixins.gui = {
    enable = lib.mkEnableOption (lib.mdDoc "gui");
    proprietary.enable = lib.mkEnableOption (lib.mdDoc "proprietary");
    creative.enable = lib.mkEnableOption (lib.mdDoc "creative");
    office.enable = lib.mkEnableOption (lib.mdDoc "office");
    # defaultBrowser=lib.mkOption
  };

  config = {
    home-manager.users.${username} = {
      # Alacritty
      programs.alacritty = {
        enable = config.mixins.gui.enable;
        settings = {
          colors = {
            bright = {
              black = "#666666";
              blue = "#3b8eea";
              cyan = "#29b8db";
              green = "#23d18b";
              magenta = "#d670d6";
              red = "#f14c4c";
              white = "#e5e5e5";
              yellow = "#f5f543";
            };
            normal = {
              black = "#000000";
              blue = "#2472c8";
              cyan = "#11a8cd";
              green = "#0dbc79";
              magenta = "#bc3fbc";
              red = "#cd3131";
              white = "#e5e5e5";
              yellow = "#e5e510";
            };
            primary = {
              background = "#030303";
              foreground = "#dddddd";
            };
          };
          font = {
            bold = {
              family = "DejaVu Sans Mono";
              style = "Bold";
            };
            bold_italic = {
              family = "DejaVu Sans Mono";
              style = "Bold Oblique";
            };
            italic = {
              family = "DejaVu Sans Mono";
              style = "Oblique";
            };
            normal = {
              family = "DejaVu Sans Mono";
              style = "Book";
            };
            size = 12.5;
          };
          window = {
            dimensions = {
              columns = 110;
              lines = 30;
            };
          };
        };
      };

      # Set alacritty as the default terminal
      home.sessionVariables."TERMINAL" = "alacritty";

      # # Thunderbird
      # programs.thunderbird.enable = true;

      home.packages =
        (
          with pkgs;
            if config.mixins.gui.enable
            then [touchegg]
            else []
        )
        ++ (
          with pkgs;
            if config.mixins.gui.enable
            then [
              # flatseal
              # loupe # Gnome image viewer # Not available in Nix yert
              anki
              bottles
              xfce.catfish # File searcher
              celluloid
              drawing
              element
              gnome.file-roller
              fluffychat
              epiphany # Gnome browser
              evince
              firefox
              fractal # Doesn't support e2e encryption yet
              gparted
              flameshot
              qdirstat
              gnome.gnome-font-viewer
              gnome.gnome-characters
              fluffychat
              gnome.cheese
              gnome.file-roller
              ladybird # SerenityOS browser
              meld
              qalculate-gtk
              simple-scan
              transmission
              vlc
              zulip
            ]
            else []
        )
        ++ (
          with pkgs;
            if config.mixins.gui.proprietary.enable
            then [
              discord
              brave-browser
              bitwig-studio
            ]
            else []
        )
        ++ (
          with pkgs;
            if config.mixins.gui.creative.enable
            then [
              krita
              blender
              handbrake
              inkscape
              drawing
              kdenlive
              gimp
              audacity
            ]
            else []
        )
        ++ (
          with pkgs;
            if config.mixins.gui.office.enable
            then [
              libreoffice
              hunspell
              hunspellDicts.en-gb-ise
            ]
            else []
        );

      # Set firefox as the default browser
      home.sessionVariables = {
        BROWSER = "firefox";
      };

      # element:
      #   flatpak: im.riot.Riot
      # epiphany:
      #   flatpak: org.gnome.Epiphany
      #   apt: epiphany-browser
      # evince:
      #   flatpak: org.gnome.Evince
      # firefox:
      #   flatpak: org.mozilla.firefox
      #   apt:
      #     comment: Installs a snap
      #     ignore: true
      #     packages: firefox
      #   nix: firefox
      # flameshot:
      #   guix: flameshot
      #   apt: flameshot
      # footage:
      #   flatpak: io.gitlab.adhami3310.Footage
      # gnome-boxes:
      #   flatpak: org.gnome.Boxes
      #   apt: gnome-boxes
      # gnome-screenshot:
      #   comment: Now built into Gnome
      #   ignore: true
      #   apt: gnome-screenshot
      # gnome-tweaks:
      #   apt: gnome-tweaks
      # gpaste:
      #   guix:
      #     ignore: true
      #     packages: gpaste
      #   apt:
      #     - gnome-shell-extension-gpaste
      #     - gpaste-2
      # helio:
      #   flatpak: fm.helio.Workstation
      # joplin:
      #   flatpak: net.cozic.joplin_desktop
      # josm:
      #   flatpak: org.openstreetmap.josm
      # lemonade:
      #   flatpak: ml.mdwalters.Lemonade
      # libre-office:
      #   flatpak: org.libreoffice.LibreOffice
      # lossless-cut:
      #   flatpak: no.mifi.losslesscut
      # marktext:
      #   flatpak: com.github.marktext.marktext
      # mission-center:
      #   flatpak: io.missioncenter.MissionCenter
      # musescore:
      #   flatpak: org.musescore.MuseScore
      # obs:
      #   flatpak: com.obsproject.Studio
      # pinta:
      #   flatpak: com.github.PintaProject.Pinta
      # pitivi:
      #   flatpak: org.pitivi.Pitivi
      # smile:
      #   flatpak: it.mijorus.smile
      # snapshot:
      #   flatpak: org.gnome.Snapshot
      # solaar:
      #   apt: solaar
      # spotify:
      #   flatpak: com.spotify.Client
      # startup-disk-creator:
      #   apt: usb-creator-gtk
    };
  };
}
