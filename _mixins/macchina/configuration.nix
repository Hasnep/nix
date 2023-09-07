{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  username = config.mixins.default.username;
  nix-std = inputs.nix-std;
in {
  options = {};

  config = {
    home-manager.users.${username} = {
      # Install macchina
      home.packages = [pkgs.macchina];

      # Configure macchina
      home.file = let
        theme-name = "my-theme";
      in {
        macchina-config = {
          enable = true;
          target = ".config/macchina/macchina.toml";
          text = inputs.nix-std.lib.serde.toTOML {
            long_uptime = true;
            theme = theme-name;
          };
        };
        macchina-theme = {
          enable = true;
          target = ".config/macchina/themes/${theme-name}.toml";
          text = nix-std.lib.serde.toTOML {
            separator = "";
            key_color = "red";
            custom_ascii.path = "~/.config/macchina/ascii/fish.txt";
            keys =
              nix-std.lib.set.map (
                name: value: (
                  nix-std.lib.string.concat [(nix-std.lib.string.replicate (10 - (nix-std.lib.string.length value)) " ") value]
                )
              ) {
                host = "Host";
                kernel = "Kernel";
                battery = "Battery";
                os = "OS";
                de = "DE";
                wm = "WM";
                distro = "Distro";
                terminal = "Terminal";
                shell = "Shell";
                packages = "Packages";
                uptime = "Uptime";
                memory = "Memory";
                machine = "Machine";
                local_ip = "Local IP";
                backlight = "Brightness";
                resolution = "Resolution";
                cpu_load = "CPU Load";
                cpu = "CPU";
              };
          };
        };
        macchina-ascii = {
          enable = true;
          target = ".config/macchina/ascii/fish.txt";
          text = nix-std.lib.string.unlines (
            nix-std.lib.list.map (x: nix-std.lib.string.concat ["  " x]) (
              nix-std.lib.string.lines (
                lib.strings.fileContents ./fish.txt
              )
            )
          );
        };
      };
    };
  };
}
