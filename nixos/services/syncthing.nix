{ local, lib, config, ... }:

let
    cfg = config.settings.nixos.services.syncthing;
    inherit (lib) mkIf;
in
{
    config = mkIf cfg {    
        services.syncthing = {
            enable = true;
            user = local.username;
            dataDir = "/home/${local.username}/Documents/";
            configDir = "/home/${local.username}/.config/syncthing/";
            overrideFolders = true;
            overrideDevices = true;

            settings = {
                devices = {
                    "desktop" = { id = "HORZPBB-TUIKUFE-XPNPGUP-ISUS6J7-3VVS6AW-HGJCRBA-CB67AHJ-4UDPQAF"; };
                    "laptop" = { id = "KIPS7XQ-OJUQDR7-QYSLXWJ-YMOM7NZ-H7PNGSK-V323JHN-EUEO7U2-MP43WQZ"; };
                    "phone" = { id = "4SM6XJW-PAY7RDD-LJN5QMT-UVNLYMA-UETJG7G-KNVZ4HP-7TJ4IKX-LKMILAP"; };
                    "server" = { id = "YOPRCA6-AFYUSFG-IWDAO5P-FD22Q2Z-QACENI2-QADPSNH-UDJR36C-PYHBUQC"; };
                };

                folders = {
                    "Music" = {
                        id = "7us1i-1qu93";
                        path = "/home/${local.username}/Music";
                        devices = [ "desktop" "laptop" "server" ];
                        ignorePerms = false;
                    };

                    "Documents" = {
                        id = "Documents";
                        path = "/home/${local.username}/Documents";
                        devices = [ "desktop" "laptop" "server" ];
                        ignorePerms = false;
                    };
                };
            };
        };
    };
}
