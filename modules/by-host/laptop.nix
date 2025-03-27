{ inputs, pkgs, ... }: {
	imports = [
		inputs.stylix.nixosModules.stylix
		../stylix.nix
		../home
		../proxy/tor
	];
	config = {
		environment.systemPackages = with pkgs; [
			bat
			broot
			bottom
			delta
			direnv
			doggo
			duf
			dust
			eza
			fd
			file
			git
			github-cli
			gping
			lazygit
			nasm
			neofetch
			neovim
			nh
			p7zip
			procs
			ripgrep
			unzip
			vim
			xdg-utils
			zip
			zoxide
		];
	};
}
