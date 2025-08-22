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

        systemd.tmpfiles.rules = [
            "d /mnt/MediaDrive/Music/ 0777 root root -"
            "d /mnt/MediaDrive/Work/ 0777 root root -"
            "d /mnt/MediaDrive/Movies/ 0777 root root -"
        ];
    };
}
