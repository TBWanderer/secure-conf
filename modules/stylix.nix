{ pkgs, ... }:
{
	stylix = {
		enable = true;
		image = ./wallpapers/blue-forest.png;
		opacity = {
			applications = 1;
		};
		fonts = rec {
			sizes = {
				terminal = 10;
			};
			serif = {
				package = pkgs.nerd-fonts.jetbrains-mono;
				name = "JetBrainsMono NF";
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
