{ lib, pkgs, inputs, ... }:
let
	modules = ../../modules;
in {
	imports = [
		./hardware-configuration.nix
		"${modules}/nvidia.nix"
	#   "${modules}/disko.nix"
	];

	boot = {
		loader = {
			systemd-boot.enable = false;
			efi.canTouchEfiVariables = false;
			grub = {
				enable = true;
				efiInstallAsRemovable = true;
				efiSupport = true;
				device = "nodev";
			};
		};
		supportedFilesystems = [ "ntfs" ];
		kernelPackages = pkgs.linuxKernel.packages.linux_6_15;
		kernelParams = [ "kvm.enable_virt_at_load=0" ];
		kernelModules = [ "tcp_bbr" ];
		kernel.sysctl = {
			# Disable magic SysRq key
    		"kernel.sysrq" = 0;
    		# Ignore ICMP broadcasts to avoid participating in Smurf attacks
    		"net.ipv4.icmp_echo_ignore_broadcasts" = 1;
    		# Ignore bad ICMP errors
    		"net.ipv4.icmp_ignore_bogus_error_responses" = 1;
    		# Reverse-path filter for spoof protection
    		"net.ipv4.conf.default.rp_filter" = 1;
    		"net.ipv4.conf.all.rp_filter" = 1;
    		# SYN flood protection
    		"net.ipv4.tcp_syncookies" = 1;
    		# Do not accept ICMP redirects (prevent MITM attacks)
    		"net.ipv4.conf.all.accept_redirects" = 0;
    		"net.ipv4.conf.default.accept_redirects" = 0;
    		"net.ipv4.conf.all.secure_redirects" = 0;
    		"net.ipv4.conf.default.secure_redirects" = 0;
    		"net.ipv6.conf.all.accept_redirects" = 0;
    		"net.ipv6.conf.default.accept_redirects" = 0;
    		# Do not send ICMP redirects (we are not a router)
    		"net.ipv4.conf.all.send_redirects" = 0;
    		# Do not accept IP source route packets (we are not a router)
    		"net.ipv4.conf.all.accept_source_route" = 0;
    		"net.ipv6.conf.all.accept_source_route" = 0;
    		# Protect against tcp time-wait assassination hazards
    		"net.ipv4.tcp_rfc1337" = 1;
    		# TCP Fast Open (TFO)
    		"net.ipv4.tcp_fastopen" = 3;
    		## Bufferbloat mitigations
    		# Requires >= 4.9 & kernel module
    		"net.ipv4.tcp_congestion_control" = "bbr";
    		# Requires >= 4.19
    		"net.core.default_qdisc" = "cake";
		};
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
		openssh = {
			enable = true;
			passwordAuthentication = false;
		};
		fail2ban = {
    		enable = true;
    		maxretry = 10;
    		bantime-increment.enable = true;
    	};

		resolved.enable = true;

		xserver.desktopManager.cinnamon.enable = true;

		greetd = {
			enable = true;
			settings = rec {
				default_session = {
					command = "${pkgs.cage}/bin/cage ${pkgs.greetd.gtkgreet}/bin/gtkgreet -- -c Hyprland";
					user = "x";
				};
			};
		};
	};

	networking = {
		hostName = "laptop";
		nameservers = [
			"100.126.179.69"
			"1.1.1.1"
			"8.8.8.8"
		];
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
		direnv = {
			enable = true;
			nix-direnv.enable = true;
		};
		steam = {
			enable = true;
			remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
			dedicatedServer.openFirewall = false; # Open ports in the firewall for Source Dedicated Server
			localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
		};
		yandex-music = {
			enable = true;
			tray.enable = true;
		};
	};

	nix = {
		package = pkgs.nixVersions.stable;
		extraOptions = ''experimental-features = nix-command flakes'';
		settings = {
			substituters = [ "https://cache.garnix.io" ];
			trusted-public-keys = [ "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=" ];
		};
		gc = {
			automatic = true;
			dates = "weekly UTC";
		};
	};

	users.users = {
		x = {
			isNormalUser = true;
			extraGroups = [
				"wheel"
				"docker"
				"vboxusers"
				"kvm"
				"networkmanager"
			];
			shell = pkgs.fish;
		};
		root.shell = pkgs.fish;
	};

	system.stateVersion = "25.05"; 
}

