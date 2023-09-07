{
  users.users.hannes = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFLnJfxLDy7PgM2UJUk2H0TkwTqSuOGUJE9zoGmi8LOm"];
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "yes";
    };
  };

  # Allow wheel group to use sudo without a password
  security.sudo.wheelNeedsPassword = false;

  # Enable Tailscale
  services.tailscale.enable = true;
}
