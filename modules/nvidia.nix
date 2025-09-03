{ config, lib, ... }: {
	options.nvidia.enable = lib.mkEnableOption "nvidia";
	config = {
    	hardware = {
			nvidia-container-toolkit.enable = true;
			nvidia = {
    	    	modesetting.enable = true;
    	    	powerManagement.enable = true;
    	    	powerManagement.finegrained = true;
    	    	open = false;
    	    	nvidiaSettings = true;
				prime = {
					offload = {
						enable = true;
						enableOffloadCmd = true;
					};

					# M-laptop conf
					intelBusId = "PCI:0:2:0";
					nvidiaBusId = "PCI:1:0:0";
				};

    	    	package = config.boot.kernelPackages.nvidiaPackages.stable;
			};
    	};
    	services.xserver.videoDrivers = [ "nvidia" ];
	};
}
