{
	description = "Flake NixOS configuration";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    	stylix.url = "github:danth/stylix/master";
		nix-ld = {
			url = "github:Mic92/nix-ld";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		home-manager = {
			url = "github:nix-community/home-manager/master";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		firefox.url = "github:nix-community/flake-firefox-nightly";
		rust-overlay.url = "github:oxalica/rust-overlay";
		pabc-nix.url = "github:proggerx/pabc-nix";
		ayugram-desktop = {
    		type = "git";
    		submodules = true;
    		url = "https://github.com/ndfined-crp/ayugram-desktop/";
		};
		disko = {
			url = "github:nix-community/disko";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		yandex-music.url = "github:cucumber-sp/yandex-music-linux/v5.57.0";
	};

	outputs = { nixpkgs, nix-ld, home-manager, disko, ... }@inputs: {
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
