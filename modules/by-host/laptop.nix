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
			tree
			bottom
			brightnessctl
			delta
			direnv
			doggo
			duf
			dust
			eza
			fd
			file
			gcc
			git
			github-cli
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
			unzip
			vim
			wireguard-tools
			xdg-utils
			zip
			zoxide
		];
	};
}
