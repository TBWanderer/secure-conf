{ inputs, pkgs, ... }: {
	imports = [
		inputs.stylix.nixosModules.stylix
		inputs.disko.nixosModules.disko
		inputs.yandex-music.nixosModules.default
		../stylix.nix
		../home
		../rust.nix
	];
	config = {
		environment.systemPackages = with pkgs; [
			bat
			bottom
			brightnessctl
			calc
			delta
			doggo
			duf
			dust
			eza
			fd
			file
			gcc
			git
			github-cli
			go
			gping
			lazygit
			nasm
			fastfetch
			neovim
			nh
			p7zip
			pamixer
			procs
			ripgrep
			translate-shell
			tree
			unzip
			vim
			wireguard-tools
			xdg-utils
			zip
			zoxide
		];
	};
}
