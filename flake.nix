{
	description = "Flake NixOS configuration";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/release-24.11";
    	stylix.url = "github:danth/stylix/release-24.11";	
		home-manager = {
			url = "github:nix-community/home-manager/release-24.11";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		firefox.url = "github:nix-community/flake-firefox-nightly";
	};

	outputs = { nixpkgs, home-manager, ... }@inputs: {
		nixosConfigurations = {
			laptop = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				specialArgs = { inherit inputs; };
				modules = [
					./config/laptop
					./modules/by-host/laptop.nix
				];
			};
		};
	};
}
