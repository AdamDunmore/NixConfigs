{ pkgs, lib, ... }: 

{
    config = {
        networking.hostName = "server";

	    boot.loader.grub.enable = true;
	    boot.loader.grub.device = "/dev/sda";
	
	    services.openssh.enable = true;
	    services.openssh.settings.PermitRootLogin = "yes";

        programs.gnupg.agent.pinentryPackage = lib.mkForce pkgs.pinentry-tty;
    };
}
