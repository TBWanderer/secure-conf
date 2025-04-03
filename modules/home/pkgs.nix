{ pkgs, inputs, system, ... }:
let unstable = import inputs.unstable { inherit system; }; in {
	home.packages = with pkgs; with inputs; [
		# Packages from inputs
		firefox.packages.${pkgs.system}.firefox-nightly-bin
		pabc-nix.packages.${pkgs.system}.default
		
		# User packages
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
	];
}
