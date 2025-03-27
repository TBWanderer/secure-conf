{ pkgs, inputs, system, ... }:
let unstable = import inputs.unstable { inherit system; }; in {
	home.packages = with pkgs; [
		inputs.firefox.packages.${pkgs.system}.firefox-nightly-bin

		cliphist
		libnotify
		swaynotificationcenter
		nemo
		rofi-wayland
		blueman
		bluez
		alsa-utils
		sutils
		wl-clipboard
		telegram-desktop
	];
}
