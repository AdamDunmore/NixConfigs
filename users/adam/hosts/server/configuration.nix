{ user, ... }:
{
    networking.hostName = "server";
    boot.loader.grub.efiSupport = true;

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
}
