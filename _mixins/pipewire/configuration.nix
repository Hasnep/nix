{
  lib,
  config,
  ...
}: let
  username = config.mixins.default.username;
in {
  options.mixins.pipewire = {
    enable = lib.mkEnableOption (lib.mdDoc "pipewire");
  };

  config = {
    security.rtkit.enable = config.mixins.pipewire.enable; # rkit is required for pipewire
    services.pipewire = {
      enable = config.mixins.pipewire.enable;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
