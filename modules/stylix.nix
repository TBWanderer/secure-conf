{ pkgs, ... }:
{
	stylix = {
		enable = true;
		image = ./wallpaper.png;
		opacity = {
			terminal = 0.8;
			desktop = 0.8;
			applications = 0.8;
		};
		fonts = rec {
			sizes = {
				terminal = 10;
			};
			serif = {
				package = (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; });
				name = "JetBrainsMono Nerd Font";
			};
			sansSerif = serif;
			monospace = serif;
			emoji = {
				package = pkgs.noto-fonts-emoji;
				name = "Noto Color Emoji";
			};
		};
		cursor = {
			name = "phinger-cursors-dark";
			size = 24;
			package = pkgs.phinger-cursors;
		};
		base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
		
		polarity = "dark";
	};
}
