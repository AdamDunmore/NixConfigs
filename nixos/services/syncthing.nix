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
                    "desktop" = { id = "HORZPBB-TUIKUFE-XPNPGUP-ISUS6J7-3VVS6AW-HGJCRBA-CB67AHJ-4UDPQAF"; };
                    "laptop" = { id = "KIPS7XQ-OJUQDR7-QYSLXWJ-YMOM7NZ-H7PNGSK-V323JHN-EUEO7U2-MP43WQZ"; };
                    "phone" = { id = "4SM6XJW-PAY7RDD-LJN5QMT-UVNLYMA-UETJG7G-KNVZ4HP-7TJ4IKX-LKMILAP"; };
                };

                folders = {
                    "Music" = {
                        path = "/home/${local.username}/Music";
                        devices = [ "desktop" "laptop" "phone" ]; #"server"
                        ignorePerms = false;
                    };
                };
            };
        };
    };
}
