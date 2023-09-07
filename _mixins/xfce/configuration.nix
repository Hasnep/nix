{
  config,
  lib,
  pkgs,
  ...
}: let
  username = config.mixins.default.username;
in {
  imports = [];

  options.mixins.xfce = {
    enable = lib.mkEnableOption (lib.mdDoc "xfce");
  };

  config = {
    services.xserver = {
      enable = config.mixins.xfce.enable;
      desktopManager = {
        xterm.enable = false;
        xfce.enable = true;
      };
      displayManager.defaultSession = "xfce";
    };

    home-manager.users.${username} = {
      # Enable the Yaru theme
      gtk = {
        enable = config.mixins.xfce.enable;
        theme = {
          name = "Yaru-dark";
          package = pkgs.yaru-theme;
        };
        cursorTheme = {
          name = "Yaru-dark";
          package = pkgs.yaru-theme;
          size = 32;
        };
        iconTheme = {
          name = "Yaru-dark";
          package = pkgs.yaru-theme;
        };
        # Enable dark theme
        gtk3.extraConfig = {gtk-application-prefer-dark-theme = true;};
        gtk4.extraConfig = {gtk-application-prefer-dark-theme = true;};
      };

      home.packages = with pkgs; [xfce.xfdashboard];

      home.file = {
        xfce-panel-config = {
          enable = config.mixins.xfce.enable;
          target = ".config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml";
          text = lib.strings.fileContents ./xfce-panel.xml;
        };
      };
    };
  };
}
