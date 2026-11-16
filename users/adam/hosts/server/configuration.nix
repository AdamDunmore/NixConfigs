{ user, ... }:
{
    # TODO
    # - Markdown webserver
    # - Music webserver
    # - Gonic or equivelant

    networking.hostName = "server";
    boot.loader.grub.efiSupport = true;

    # SSH Setup
    users.users.${user}.openssh.authorizedKeys.keys = [
       "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILKnY5DiA9KjX27MCMAX7rk55Tt1jDqemu9az6y9qKAp shared-nixos" 
    ];

    services.openssh = {
        enable = true;
        settings = {
            PasswordAuthentication = false;
            KbdInteractiveAuthentication = false;
            PermitRootLogin = "prohibit-password";
            AuthenticationMethods = "publickey";
        };
    };

    # Syncthing TS addr
    services.syncthing = {
        settings.options.listenAddresses = [ "tcp://100.66.5.15:22000" ];
        guiAddress = "100.66.5.15:8384";
    };
}
