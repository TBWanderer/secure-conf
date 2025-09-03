{ pkgs, inputs, system, ... }:
let 
	system = pkgs.system;
	unstable = import inputs.unstable { 
		inherit system; 
		config.allowUnfree = true; # if you need unfree packages
	};
in {
	home.packages = with pkgs; with inputs; [
		# Packages from inputs
		firefox.packages.${pkgs.system}.firefox-nightly-bin
		pabc-nix.packages.${pkgs.system}.default
		ayugram-desktop.packages.${pkgs.system}.ayugram-desktop
		
		# User packages
		# android-studio-full

		telegram-desktop

		python3
		python3Packages.pip
		jetbrains.pycharm-community-bin
		gajim
		clock-rs
		go
		prismlauncher
		transmission_3-gtk
		vesktop
		cliphist
		libnotify
		swaynotificationcenter
		blueman
		bluez
		bluetui
		alsa-utils
		sutils
		wl-clipboard
		aseprite
		tor-browser
		libreoffice-fresh
		r2modman
		winetricks
		wineWowPackages.waylandFull
		obsidian
	];
}
