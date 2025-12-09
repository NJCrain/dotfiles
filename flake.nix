{
  description = "Home Manager configuration of nick";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }:
    {
      homeConfigurations = {
        "nick@nix-desktop" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { system = "x86_64-linux"; };
          modules = [ ./home.nix ];

          # Optionally use extraSpecialArgs
          # to pass through arguments to home.nix
        };
        "nick@nix-server" = home-manager.lib.homeManagerConfiguration {
					pkgs = import nixpkgs { system = "x86_64-linux"; };
					modules = [ ./home.nix ];
        };
      	"nick@Nicks-MacBook-Air" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { system = "aarch64-darwin"; config.allowUnfree = true; };
          modules = [ ./work-laptop.nix ];
        };
      };
    };
}
