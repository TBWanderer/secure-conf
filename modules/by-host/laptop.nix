{ inputs, pkgs, ... }: {
	imports = [
		inputs.stylix.nixosModules.stylix
		../stylix.nix
		../home
		../rust.nix
	];
	config = {
		environment.systemPackages = with pkgs; [
			bat
			tree
			bottom
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
