{
  description = "Bootstrap ISO";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =  {
    self,
    nixpkgs,
    nixos-generators,
    ...
  }: {
    packages.x86_64-linux = {
      bootstrap-iso = nixos-generators.nixosGenerate {
        system = "x86_64-linux";
        modules = [./bootstrap.nix];
        format = "iso";
      };
      bootstrap-install-iso = nixos-generators.nixosGenerate {
        system = "x86_64-linux";
        modules = [./bootstrap.nix];
        format = "install-iso";
      };
    };
  };
}
