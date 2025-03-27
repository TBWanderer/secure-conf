{ lib, pkgs, inputs, ... }:
{
	imports = [ ./hardware-configuration.nix ];

	boot = {
		loader = {
			systemd-boot.enable = false;
			efi = {
				canTouchEfiVariables = false;
			};
			grub = {
				enable = true;
				efiInstallAsRemovable = true;
				efiSupport = true;
				device = "nodev";
			};
		};
		supportedFilesystems = [ "ntfs" ];
		kernelPackages = pkgs.linuxKernel.packages.linux_6_13;
	};

	hardware = {
		bluetooth = {
			enable = true;
			powerOnBoot = true;
		};
		pulseaudio.enable = lib.mkForce false;
	};

	services = {
		pipewire = {
			enable = true;
			pulse.enable = true;
		};

		tailscale.enable = true;
		blueman.enable = true;
		libinput.enable = true;
		openssh.enable = true;
		getty.autologinUser = "x";
		resolved.enable = true;

		xserver = {
			desktopManager.cinnamon.enable = true;	
		};
	};

	networking = {
		hostName = "laptop";
		networkmanager.enable = true;
		proxy = {
		# 	default = "http://user:password@host.com:1234/";
		# 	noProxy = "127.0.0.1,localhost";
		};
		firewall = {
			enable = false;
		# 	allowedTCPPorts = [ ... ];
		# 	allowedUDPPorts = [ ... ];
		};
	};
	
	xdg.portal.enable = true;

	time.timeZone = "Europe/Moscow";

	nixpkgs.config.allowUnfree = true;

	environment.sessionVariables = {
		PATH = [
			"/usr/bin"
			"/home/x/.local/bin"
			"/home/x/.cargo/bin"
		];
		EDITOR = "vim";
		DIRENV_LOG_FORMAT = "";
	};

	fonts.packages = with pkgs; [( (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; }) )];
	
	virtualisation = { docker.enable = true; };

	programs = {
		git.enable = true;
		hyprland.enable = true;
		fish.enable = true;
		nix-ld.enable = true;
		starship.enable = true;
	};

	nix = {
		package = pkgs.nixVersions.stable;
		extraOptions = ''experimental-features = nix-command flakes'';
		settings = {
			substituters = [ "https://cache.garnix.io" ];
			trusted-public-keys = [ "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=" ];
		};
	};

	users.users = {
		x = {
			isNormalUser = true;
			extraGroups = [ "wheel" "docker" ];
			shell = pkgs.fish;
		};
		root.shell = pkgs.fish;
	};

	system.stateVersion = "24.11"; 
}

