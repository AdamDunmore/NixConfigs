{ pkgs, lib, config, ... }: 

{
    config = {
        networking.hostName = "server";

	    boot.loader.grub.enable = true;
	    boot.loader.grub.device = "/dev/sda";
	
	    services.openssh.enable = true;
	    services.openssh.settings.PermitRootLogin = "yes";

        programs.gnupg.agent.pinentryPackage = lib.mkForce pkgs.pinentry-tty;

        users.users."server" = {
            group = "users";
            createHome = true;
            isNormalUser = true;
            description = "";
            extraGroups = [ "networkmanager" "wheel" "audio" "dialout" ];
            shell = pkgs.zsh;
            ignoreShellProgramCheck = true;
            hashedPasswordFile = config.sops.secrets.server_pass.path;
        };
    };
}
