{ config, lib, pkgs, ... }: {
  options.nvidia.enable = lib.mkEnableOption "nvidia";
  
  config = lib.mkIf config.nvidia.enable {
    hardware = {
      nvidia-container-toolkit.enable = true;
      
      nvidia = {
        modesetting.enable = true;
        
        # CRITICAL: Power management fixes for suspend/resume
        powerManagement = {
          enable = true;  # Enable suspend/resume support
          finegrained = false;  # IMPORTANT: Set to false for better suspend stability
        };
        
        open = false;  # Use proprietary drivers
        nvidiaSettings = true;
        
        prime = {
          offload = {
            enable = true;
            enableOffloadCmd = true;
          };
          
          # Your laptop configuration
          intelBusId = "PCI:0:2:0";
          nvidiaBusId = "PCI:1:0:0";
        };
        
        package = config.boot.kernelPackages.nvidiaPackages.stable;
      };
    };
    
    # Video driver configuration
    services.xserver.videoDrivers = [ "nvidia" ];
    
    # Create tmpfiles for NVIDIA VRAM preservation during suspend
    systemd.tmpfiles.rules = [
      "d /var/tmp 1777 root root -"
    ];
  };
}
