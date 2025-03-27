{
	programs = {
		kitty.enable = true;
		alacritty.enable = true;
		home-manager.enable = true;
	};

	imports = [
		./fish.nix
		./hyprland.nix
	];
}
