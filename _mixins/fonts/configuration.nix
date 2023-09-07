{
  config,
  pkgs,
  lib,
  ...
}: let
  username = config.mixins.default.username;
in {
  options.mixins.fonts = {
    enable = lib.mkEnableOption (lib.mdDoc "fonts");
  };
  config = {
    home-manager.users.${username} = {
      home.packages = (
        with pkgs;
          if config.mixins.fonts.enable
          then [
            # bebas-neue
            # cmu
            # lobster
            # lobstertwo
            arphic-ukai
            comic-mono
            comic-neue
            dejavu_fonts
            emojione
            fira
            fira-code
            fira-mono
            ibm-plex
            inconsolata
            ttf-tw-moe # Taiwan MOE fonts
            jetbrains-mono
            julia-mono
            lmmath # Latin Modern Math
            lmodern # Latin Modern
            noto-fonts
            noto-fonts-cjk-sans
            noto-fonts-cjk-serif
            noto-fonts-color-emoji
            stix-otf
            stix-two
          ]
          else []
      );
    };
  };
}
