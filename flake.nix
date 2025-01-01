{
  description = "Kayvan System Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs"; ## use our nixpkgs instead of HM one
    };
    iohk-hix = {
      url = "github:input-output-hk/haskell.nix";
    };
  };

  outputs =
  { self
  , nixpkgs
  # , nurpkgs , text2nix
  , home-manager
  , iohk-hix
  , hyprland
  , hyprland-plugins
  , ... } @ inputs:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config = { allowUnfree = true; };
    };
    lib = nixpkgs.lib;


  in {
    homeManagerConfigurations = {
      kayvan = home-manager.lib.homeManagerConfiguration {
      extraSpecialArgs = { inherit inputs; };
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [
          ./users/kayvan/home.nix
          {
            home = {
              username = "kayvan";
              homeDirectory = "/home/kayvan";
              stateVersion = "24.05";
            };
          }
        ];
      };
    };

    nixosConfigurations = {
      saturn-xeon = lib.nixosSystem { ## gets all the system stuff by hostname
      inherit system;
      specialArgs = { inherit inputs; };
      modules = [
        ./system/configuration.nix
      ];
      };
    };
  };
}
