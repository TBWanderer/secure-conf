{ inputs, config, ... }:
{
	imports = [ inputs.home-manager.nixosModules.home-manager ];

	home-manager = {
		useGlobalPkgs = true;
		useUserPackages = true;
		backupFileExtension = "old";
		
		users = {
			x = {
				home = {
					username = "x";
					homeDirectory = "/home/x";
				};

    			imports = [ ./pkgs.nix ./programs ];

    			home.stateVersion = "25.05";
			};
		};

		extraSpecialArgs = {
			inherit inputs;
			sys = config;
		};
	};
}

