{ lib, pkgs, inputs, ... }:

let
  modules = ../../modules;
in {
  imports = [
    ./hardware-configuration.nix
    "${modules}/gnome.nix"  # Separated GNOME configuration
    "${modules}/nvidia.nix"
    # "${modules}/disko.nix"
  ];

  # ==================== Boot Configuration ====================
  boot = {
    loader = {
      systemd-boot.enable = false;
      efi.canTouchEfiVariables = false;
      grub = {
        enable = true;
        efiInstallAsRemovable = true;
        efiSupport = true;
        device = "nodev";
        theme = lib.mkForce (pkgs.catppuccin-grub.overrideAttrs { flavor = "macchiato"; });
      };
    };

    supportedFilesystems = [ "ntfs" ];
    kernelPackages = pkgs.linuxPackages_latest;
    
    # CRITICAL: Kernel parameters for NVIDIA suspend fixes
    kernelParams = [
      "kvm.enable_virt_at_load=0"
      
      # NVIDIA suspend/resume fixes
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"  # Save VRAM on suspend
      "nvidia.NVreg_TemporaryFilePath=/var/tmp"        # Where to save VRAM
      "nvidia-drm.modeset=1"                           # Enable modesetting
      "nvidia-drm.fbdev=1"                             # Better framebuffer support
      "mem_sleep_default=deep"                         # Use deep sleep
      
      # Additional stability parameters
      "ibt=off"                                        # Fix for newer Intel CPUs
      "acpi_osi=Linux"                                 # Better ACPI compatibility
    ];
    
    # Load NVIDIA modules early
    initrd.kernelModules = [ 
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
    ];
    
    kernelModules = [ "tcp_bbr" ];
    blacklistedKernelModules = [ "nouveau" ];  # Prevent nouveau from interfering
    
    # Sysctl optimizations
    kernel.sysctl = {
      # ===== Security Hardening =====
      "kernel.sysrq" = 0;
      "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
      "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
      "net.ipv4.conf.default.rp_filter" = 1;
      "net.ipv4.conf.all.rp_filter" = 1;
      "net.ipv4.tcp_syncookies" = 1;
      "net.ipv4.conf.all.accept_redirects" = 0;
      "net.ipv4.conf.default.accept_redirects" = 0;
      "net.ipv4.conf.all.secure_redirects" = 0;
      "net.ipv4.conf.default.secure_redirects" = 0;
      "net.ipv6.conf.all.accept_redirects" = 0;
      "net.ipv6.conf.default.accept_redirects" = 0;
      "net.ipv4.conf.all.send_redirects" = 0;
      "net.ipv4.conf.all.accept_source_route" = 0;
      "net.ipv6.conf.all.accept_source_route" = 0;
      "net.ipv4.tcp_rfc1337" = 1;
      
      # ===== Performance Tuning =====
      "net.ipv4.tcp_fastopen" = 3;
      "net.ipv4.tcp_congestion_control" = "bbr";
      "net.core.default_qdisc" = "cake";
    };
  };

  # ==================== Hardware Configuration ====================
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    
    # Enable graphics acceleration
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  # Enable NVIDIA module with fixes
  nvidia.enable = true;
  gnome.enable = true;

  # ==================== Swap Configuration ====================
  swapDevices = lib.mkForce [{
    device = "/var/lib/swapfile";
    size = 16 * 1024; # 16 GB
  }];

  # ==================== SystemD Services ====================
  systemd = {
    # CRITICAL FIX: Prevent systemd from freezing user sessions during suspend
    services."systemd-suspend".environment = {
      SYSTEMD_SLEEP_FREEZE_USER_SESSIONS = "false";
    };
  };

  # ==================== Services Configuration ====================
  services = {
    # Audio
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
    };

    # System services
    blueman.enable = true;
    libinput.enable = true;
    resolved.enable = true;
    
    # Security services
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };
    
    fail2ban = {
      enable = true;
      maxretry = 10;
      bantime-increment.enable = true;
    };
  };

  # ==================== Networking Configuration ====================
  networking = {
    hostName = "laptop";
    networkmanager.enable = true;
    
    nameservers = [
      "100.126.179.69"  # Likely Tailscale DNS
      "1.1.1.1"         # Cloudflare DNS
      "8.8.8.8"         # Google DNS
    ];
    
    firewall = {
      enable = true;
      # allowedTCPPorts = [ ];
      # allowedUDPPorts = [ ];
    };
  };

  # ==================== System Configuration ====================
  time.timeZone = "Europe/Moscow";

  # ==================== Package Configuration ====================
  nixpkgs.config = {
    allowUnfree = true;
    android_sdk.accept_license = true;
  };

  environment = {
    # Session variables
    sessionVariables = {
      EDITOR = "vim";
      DIRENV_LOG_FORMAT = "";
      # Better NVIDIA performance
      __GL_GSYNC_ALLOWED = "1";
      __GL_VRR_ALLOWED = "1";
      # Custom terminal colors
      NEWT_COLORS = "root=black,black;window=black,black;border=white,black;listbox=white,black;label=blue,black;checkbox=red,black;title=green,black;button=white,red;actsellistbox=white,red;actlistbox=white,gray;compactbutton=white,gray;actcheckbox=white,blue;entry=lightgray,black;textbox=blue,black";
    };
    
    # Add system packages
    systemPackages = with pkgs; [
      vim
      wget
      curl
      git
    ];
  };

  # ==================== Fonts Configuration ====================
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
    corefonts
    vista-fonts
  ];

  # ==================== Virtualization ====================
  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = true;
      enableNvidia = true;  # Enable NVIDIA support for Docker
    };
    
    virtualbox = {
      host = {
        enable = true;
        enableExtensionPack = true;
      };
    };
  };

  # ==================== Programs Configuration ====================
  programs = {
    git.enable = true;
    fish.enable = true;
    starship.enable = true;
    nix-ld.enable = true;
    
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    
    steam = {
      enable = true;
      remotePlay.openFirewall = false;
      dedicatedServer.openFirewall = false;
      localNetworkGameTransfers.openFirewall = true;
    };
    
    yandex-music = {
      enable = true;
      tray.enable = true;
    };
  };

  # ==================== Nix Configuration ====================
  nix = {
    package = pkgs.nixVersions.stable;
    
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      show-trace = true;
    };
    
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  # ==================== Users Configuration ====================
  users.users = {
    x = {
      isNormalUser = true;
      shell = pkgs.fish;
      extraGroups = [
        "wheel"
        "docker"
        "vboxusers"
        "kvm"
        "networkmanager"
        "adbusers"
        "video"  # For NVIDIA access
        "audio"
      ];
    };
    
    root.shell = pkgs.fish;
  };

  system.stateVersion = "25.05";
}
