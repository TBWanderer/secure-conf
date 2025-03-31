{
	description = "Flake NixOS configuration";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/release-24.11";
    	stylix.url = "github:danth/stylix/release-24.11";	
		nix-ld = {
			url = "github:Mic92/nix-ld";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		home-manager = {
			url = "github:nix-community/home-manager/release-24.11";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		firefox.url = "github:nix-community/flake-firefox-nightly";
		rust-overlay.url = "github:oxalica/rust-overlay";
		pabc-nix.url = "github:proggerx/pabc-nix";
	};

	outputs = { nixpkgs, nix-ld, home-manager, ... }@inputs: {
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
