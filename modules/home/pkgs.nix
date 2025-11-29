{ pkgs, inputs, system, ... }:
{
	home.packages = with pkgs; with inputs; [
		# Packages from inputs
		firefox.packages.${pkgs.system}.firefox-nightly-bin
		pabc-nix.packages.${pkgs.system}.default
		ayugram-desktop.packages.${pkgs.system}.ayugram-desktop
		
		# User packages
		# android-studio-full

		telegram-desktop
		chromium

		kdePackages.kolourpaint
		android-studio
		onlyoffice-desktopeditors
		pix
		freecad
		python3
		python3Packages.pip
		gajim
		clock-rs
		go
		prismlauncher
		transmission_4-gtk
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
		r2modman
		winetricks
		wineWowPackages.waylandFull
		obsidian
	];
}
