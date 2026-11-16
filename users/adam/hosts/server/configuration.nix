{ lib, user, ... }:
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

    # Gonic Setup
    systemd.services.gonic.serviceConfig = {
        ProtectHome = lib.mkForce "tmpfs";
        BindReadOnlyPaths = [ "/home/adam/Music" ];
        StateDirectory = "gonic";
        StateDirectoryMode = "0755";
    };

    systemd.tmpfiles.rules = [
        "d /var/lib/gonic/podcasts 0755 adam users -"
        "d /var/lib/gonic/playlists 0755 adam users -"
    ];

    services.gonic = {
        enable = true;
        settings = {
            music-path = "/home/${user}/Music";            
            podcast-path = "/var/lib/gonic/podcasts";            
            playlists-path = "/var/lib/gonic/playlists"; 
            listen-addr = "100.66.5.15:4747";
            scan-interval = 1440;
        };
    };
}
