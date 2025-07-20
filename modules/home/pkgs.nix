{ pkgs, inputs, system, ... }:
let unstable = import inputs.unstable { inherit system; }; in {
	home.packages = with pkgs; with inputs; [
		# Packages from inputs
		firefox.packages.${pkgs.system}.firefox-nightly-bin
		pabc-nix.packages.${pkgs.system}.default
		ayugram-desktop.packages.${pkgs.system}.ayugram-desktop
		
		# User packages
		# android-studio-full
		prismlauncher
		transmission_3-gtk
		vesktop
		cliphist
		libnotify
		swaynotificationcenter
		nemo
		blueman
		bluez
		alsa-utils
		sutils
		wl-clipboard
		telegram-desktop
		aseprite
		tor-browser
		libreoffice-fresh
		grim
		slurp
		imagemagickBig
		r2modman
		winetricks
		wineWowPackages.waylandFull
		obsidian
	];
}
