{ lib, pkgs, inputs, ... }:
{
	imports = [ ./hardware-configuration.nix ./nvidia.nix ];

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
		kernelPackages = pkgs.linuxKernel.packages.linux_6_14;
		kernelParams = [ "kvm.enable_virt_at_load=0" ];
	};

	hardware = {
		bluetooth = {
			enable = true;
			powerOnBoot = true;
		};
	};

	nvidia.enable = true;

	services = {
		pipewire = {
			enable = true;
			pulse.enable = true;
		};

		pulseaudio.enable = false;
		tailscale.enable = true;
		blueman.enable = true;
		libinput.enable = true;
		openssh.enable = true;
		resolved.enable = true;

		xserver = {
			desktopManager.cinnamon.enable = true;
		};

		greetd = {
			enable = true;
			settings = rec {
				default_session = {
					command = "${pkgs.cage}/bin/cage ${pkgs.greetd.gtkgreet}/bin/gtkgreet";
					user = "x";
				};
			};
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

	fonts.packages = with pkgs; [
		nerd-fonts.jetbrains-mono
		noto-fonts
		corefonts
		vistafonts
	];
	
	virtualisation = {
		docker.enable = true;
		virtualbox = {
			host = {
				enable = true;
				enableExtensionPack = true;
			};
		};
	};

	programs = {
		git.enable = true;
		hyprland.enable = true;
		fish.enable = true;
		nix-ld.enable = true;
		starship.enable = true;
		steam = {
			enable = true;
			remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
			dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
			localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
		};
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
			extraGroups = [ "wheel" "docker" "vboxusers" ];
			shell = pkgs.fish;
		};
		root.shell = pkgs.fish;
	};

	system.stateVersion = "24.11"; 
}

