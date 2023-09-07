{
  description = "";

  inputs = {
    nixpkgs = {url = "github:nixos/nixpkgs/nixos-unstable";};
    nixpkgs-stable = {url = "github:nixos/nixpkgs/nixos-23.05";};
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-std = {
      url = "github:chessai/nix-std";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    disko,
    nix-std,
    hyprland,
    ...
  }: let
    makeNixOsConfig = machineName: {
      architecture,
      username,
    }: (
      nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        system = architecture;
        modules =
          [
            disko.nixosModules.disko
            ./_mixins/default/configuration.nix
            # ./_mixins/disk/configuration.nix
            ./_mixins/editors/configuration.nix
            ./_mixins/fish/configuration.nix
            ./_mixins/git/configuration.nix
            ./_mixins/macchina/configuration.nix
            ./_mixins/network/configuration.nix
            ./_mixins/pipewire/configuration.nix
            ./_mixins/gui/configuration.nix
            ./_mixins/pcloud/configuration.nix
          ]
          ++ [
            ./_mixins/hyprland/configuration.nix
            ./_mixins/xfce/configuration.nix
          ]
          ++ [
            ./${machineName}/hardware.nix
            ./${machineName}/configuration.nix
          ]
          ++ [home-manager.nixosModules.home-manager];
      }
    );
    makeNixOsConfigs = x: {nixosConfigurations = nix-std.lib.set.map makeNixOsConfig x;};
  in
    makeNixOsConfigs {
      dello = {
        username = "hannes";
        architecture = "x86_64-linux";
      };
      vm = {
        username = "hannes";
        architecture = "x86_64-linux";
      };
      xiaobai = {
        username = "hannes";
        architecture = "x86_64-linux";
      };
      pai = {
        username = "hannes";
        architecture = "aarch64-linux";
      };
    };
}
