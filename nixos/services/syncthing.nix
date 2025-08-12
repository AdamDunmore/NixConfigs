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
                    "laptop" = { id = "KIPS7XQ-OJUQDR7-QYSLXWJ-YMOM7NZ-H7PNGSK-V323JHN-EUEO7U2-MP43WQZ"; };
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
