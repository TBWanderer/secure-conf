{ inputs, config, pkgs, ... }:
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
          stateVersion = "25.05";
        };
        
        # Import additional home-manager modules
        imports = [
          ./pkgs.nix
          ./programs
        ];

		stylix = {
			iconTheme = {
				enable = true;
				package = pkgs.adwaita-icon-theme;
				light = "Adwaita";
				dark = "Adwaita";
			};
		};
      };
    };
    
    extraSpecialArgs = {
      inherit inputs;
      sys = config;
    };
  };
}
