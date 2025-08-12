{ local, lib, config, ... }:

let
    cfg = config.settings.nixos.services.syncthing;
in
{
    config = lib.mkIf cfg {    
        services.syncthing = {
            enable = true;
            user = local.username;
            dataDir = "/home/${local.username}/Documents/";
            configDir = "/home/${local.username}/.config/syncthing/";
            overrideFolders = true;
            overrideDevices = true;

            settings = {
                devices = {
                    # "server" = { id = ""; };
                    "desktop" = { id = "BUUBAHB-J32JMCM-XMM6TA5-L3RT7IK-73NZNID-3K3VSIQ-GOWRST2-CUSVJAO"; };
                    "laptop" = { id = "3QDOA7N-HNVYBEV-WHCA6EX-KSSL6O4-ECRELZ7-YVG2CKI-OTZ3AID-GZ2LMAL"; };
                };

                folders = {
                    "Music" = {
                        path = "/home/${local.username}/Music";
                        devices = [ "desktop" "laptop" ]; #"server"
                        ignorePerms = false;
                    };
                };
            };
        };
    };
}
