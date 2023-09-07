{
  config,
  lib,
  ...
}: let
  username = config.mixins.default.username;
in {
  imports = [];

  options.mixins.network = {
    hostName = lib.mkOption {
      type = lib.types.str;
    };
  };

  config = {
    # Set host name
    networking.hostName = config.mixins.network.hostName;

    # Enable the OpenSSH daemon.
    services.openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
      settings.KbdInteractiveAuthentication = false;
      settings.PermitRootLogin = "yes";
    };

    # Enable SSH again? Not sure what this does
    services.sshd.enable = true;

    # Enable Tailscale
    services.tailscale.enable = true;

    # Networking
    networking = {
      networkmanager.enable = true;

      # # Disable network manager in favour of declarative network configuration
      # networkmanager.enable = false;
      # # Set up wi-fi
      # wireless = {
      #   enable = true;
      #   # allowAuxiliaryImperativeNetworks = true;
      #   # userControlled = {
      #   #   enable = true;
      #   #   group = "network";
      #   # };
      #   # Add wifi-networks
      #   networks = { };
      # };
    };
  };
}
