{ config, lib, ... }: {
	options.nvidia.enable = lib.mkEnableOption "nvidia";
	config = {
    	hardware.nvidia = {
    	    modesetting.enable = true;
    	    powerManagement.enable = false;
    	    powerManagement.finegrained = false;
    	    open = false;
    	    nvidiaSettings = true;
    	    package = config.boot.kernelPackages.nvidiaPackages.beta;
    	};
    	services.xserver.videoDrivers = [ "nvidia" ];
	};
}
