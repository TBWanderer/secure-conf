{ ... }:
{
	programs.fish = let config_path = "/home/x/nixos-conf"; in {
		enable = true;
		interactiveShellInit = ''
			set fish_greeting
		'';
		loginShellInit = ''
			echo $(tty) | grep "tty" && Hyprland
		'';
		shellAliases = {
			q = "exit";
			l = "ls -a -F";
			ls = "eza --icons";
			lg = "lazygit";
			cls = "clear";
			c = "clear";
			o = "nvim";
			og = "neovide";
			vim = "nvim";
			light = "brightnessctl s";
			update = "nh os switch ${config_path}";
			deploy = "nix run github:serokell/deploy-rs -- -s ${config_path}#suserv";
		};
	};
}
