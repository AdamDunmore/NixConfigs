{ pkgs, inputs, ... }: 

{
    config = {
        networking.hostName = "server";

	boot.loader.grub.enable = true;
	boot.loader.grub.device = "/dev/sda";
	
	services.openssh.enable = true;
	services.openssh.settings.PermitRootLogin = "yes";

	services.jellyfin = {
	  enable = true;
	};
	networking.firewall.allowedTCPPorts = [ 8096 ];
    };
}
