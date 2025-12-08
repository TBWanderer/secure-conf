{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.gnome;
  
  # Extract extension UUIDs automatically
  extensionUuids = map (ext: ext.extensionUuid) cfg.extensions;
in
{
  # ==================== Module Options ====================
  options.gnome = {
    enable = mkEnableOption "GNOME Desktop Environment";
    
    extensions = mkOption {
      type = types.listOf types.package;
      default = with pkgs.gnomeExtensions; [
        toggle-proxy
        appindicator
        clipboard-indicator
      ];
      description = "List of GNOME Shell extensions to install and enable";
      example = literalExpression ''
        with pkgs.gnomeExtensions; [
          appindicator
          dash-to-dock
          blur-my-shell
        ]
      '';
    };
    
    excludePackages = mkOption {
      type = types.listOf types.package;
      default = with pkgs; [
        cheese epiphany evince geary gedit
        gnome-characters gnome-music gnome-photos
        gnome-tour hitori iagno tali totem
        yelp gnome-maps gnome-weather simple-scan
        snapshot showtime
      ];
      description = "GNOME packages to exclude from installation";
    };
    
    favoriteApps = mkOption {
      type = types.listOf types.str;
      default = [
        "org.gnome.Nautilus.desktop"
        "org.gnome.Settings.desktop"
      ];
      description = "Favorite applications in GNOME dock";
    };
    
    interface = {
      colorScheme = mkOption {
        type = types.enum [ "default" "prefer-dark" "prefer-light" ];
        default = "prefer-dark";
        description = "GNOME color scheme preference";
      };
      
      enableHotCorners = mkOption {
        type = types.bool;
        default = false;
        description = "Enable hot corners";
      };
      
      showBatteryPercentage = mkOption {
        type = types.bool;
        default = true;
        description = "Show battery percentage in top bar";
      };
    };
    
    power = {
      sleepInactiveAcTimeout = mkOption {
        type = types.int;
        default = 3600;
        description = "Sleep timeout when on AC power (seconds)";
      };
      
      sleepInactiveBatteryTimeout = mkOption {
        type = types.int;
        default = 900;
        description = "Sleep timeout when on battery (seconds)";
      };
      
      powerButtonAction = mkOption {
        type = types.enum [ "nothing" "suspend" "hibernate" "interactive" ];
        default = "suspend";
        description = "Action when power button is pressed";
      };
    };
    
    touchpad = {
      tapToClick = mkOption {
        type = types.bool;
        default = true;
        description = "Enable tap-to-click";
      };
      
      naturalScroll = mkOption {
        type = types.bool;
        default = true;
        description = "Enable natural scrolling";
      };
    };
    
    nightLight = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable night light";
      };
      
      temperature = mkOption {
        type = types.int;
        default = 3700;
        description = "Night light color temperature (1000-10000)";
      };
    };
    
    extraDconfSettings = mkOption {
      type = types.attrs;
      default = {};
      description = "Additional dconf settings";
      example = literalExpression ''
        {
          "org/gnome/desktop/wm/preferences" = {
            num-workspaces = 6;
          };
        }
      '';
    };
  };

  # ==================== Module Configuration ====================
  config = mkIf cfg.enable {
    # Enable required services
    services = {
      xserver = {
        enable = true;
        excludePackages = [ pkgs.xterm ];
      };
      
      displayManager = {
        gdm.enable = true;
        defaultSession = "gnome";
      };
      
      desktopManager.gnome.enable = true;
      udev.packages = with pkgs; [ gnome-settings-daemon ];
    };

    # XDG Portal
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };

    # Package management
    environment = {
      gnome.excludePackages = cfg.excludePackages;
      
      systemPackages = cfg.extensions ++ (with pkgs; [
        adwaita-icon-theme
        gnome-tweaks
      ]);
    };

    # Home Manager configuration
    home-manager.users.x.dconf.settings = mkMerge [
      {
        # Shell configuration
        "org/gnome/shell" = {
          disable-user-extensions = false;
          enabled-extensions = extensionUuids;
          favorite-apps = cfg.favoriteApps;
        };

        # Interface settings
        "org/gnome/desktop/interface" = {
          color-scheme = cfg.interface.colorScheme;
          enable-hot-corners = cfg.interface.enableHotCorners;
          clock-show-weekday = true;
          show-battery-percentage = cfg.interface.showBatteryPercentage;
        };

        # Window management
        "org/gnome/desktop/wm/preferences" = {
          button-layout = "appmenu:minimize,maximize,close";
          num-workspaces = 5;
        };

        # Mutter settings
        "org/gnome/mutter" = {
          dynamic-workspaces = false;
          edge-tiling = true;
          workspaces-only-on-primary = true;
        };

        # Power settings
        "org/gnome/settings-daemon/plugins/power" = {
          sleep-inactive-ac-timeout = cfg.power.sleepInactiveAcTimeout;
          sleep-inactive-battery-timeout = cfg.power.sleepInactiveBatteryTimeout;
          power-button-action = cfg.power.powerButtonAction;
        };

        # Touchpad settings
        "org/gnome/desktop/peripherals/touchpad" = {
          tap-to-click = cfg.touchpad.tapToClick;
          two-finger-scrolling-enabled = true;
          natural-scroll = cfg.touchpad.naturalScroll;
        };

        # Privacy settings
        "org/gnome/desktop/privacy" = {
          remember-recent-files = true;
          recent-files-max-age = 30;
          remove-old-temp-files = true;
          remove-old-trash-files = true;
        };

        # File chooser
        "org/gtk/settings/file-chooser" = {
          sort-directories-first = true;
          show-hidden = false;
        };

        # Nautilus
        "org/gnome/nautilus/preferences" = {
          default-folder-viewer = "list-view";
          show-delete-permanently = true;
          show-hidden-files = false;
        };

        # Keyboard shortcuts
        "org/gnome/desktop/wm/keybindings" = {
          close = ["<Super>c"];
          switch-applications = [];
          switch-windows = ["<Alt>Tab"];
        };

        # Night Light
        "org/gnome/settings-daemon/plugins/color" = mkIf cfg.nightLight.enable {
          night-light-enabled = true;
          night-light-schedule-automatic = true;
          night-light-temperature = mkDefault cfg.nightLight.temperature;
        };
      }
      cfg.extraDconfSettings
    ];
  };
}
