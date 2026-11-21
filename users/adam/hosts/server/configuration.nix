{ lib, user, inputs, pkgs, ... }:
let
    docsDir = "/home/${user}/Notes";
    port = 4040;
in
{
    imports = [ inputs.webserver.nixosModules.default ];

    networking.hostName = "server";
    boot.loader.grub.efiSupport = true;

    # Tmp Files
    systemd.tmpfiles.rules = [
        "d /var/lib/gonic/podcasts 0755 ${user} users -"
        "d /var/lib/gonic/playlists 0755 ${user} users -"
        "d ${docsDir} 0755 ${user} users -"
    ];

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

    # Webserver setup
    services.webserver = {
        enable = true;
        user = user;
        environmentVariables = {
            WEBSERVER_IP = "100.66.5.15";
            WEBSERVER_PORT = "1913";
        };
        passwordFile = "/home/adam/p.txt"; # TODO move file to sops
    };

    # Vivify Setup
    systemd.services.vivify = {
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        environment = {
            VIV_PORT = toString port;
            VIV_TIMEOUT = "0";
        };
        serviceConfig = {
            ExecStart = "${pkgs.vivify}/bin/vivify-server";
            User = user;
            Restart = "on-failure";

            NoNewPrivileges = true;
            PrivateTmp = true;
            PrivateDevices = true;
            ProtectProc = "invisible";
            ProcSubset = "pid";
            TemporaryFileSystem = [ "/:ro" ];
            BindReadOnlyPaths = [ "/nix/store" docsDir ];
        };
    };

    networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 4040 ];
}
