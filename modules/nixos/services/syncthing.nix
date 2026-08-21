{ lib, config, user, ... }:

let
    cfg = config.settings.modules.nixos.services.syncthing;
    inherit (lib) mkIf;
in
{
    config = mkIf cfg.enable {    
        services.syncthing = {
            enable = true;
            user = user;
            dataDir = "/home/${user}/";
            configDir = "/home/${user}/.config/syncthing";
            overrideFolders = true;
            overrideDevices = true;

            settings = {
                devices = {
                    "desktop" = { id = "DIZXZOG-IIRYVVX-F2IYNJH-HD6TZNG-VCKQULR-PVNGL7Z-7HMA4KN-ZF66RAU"; };
                    "laptop" = { id = "KIPS7XQ-OJUQDR7-QYSLXWJ-YMOM7NZ-H7PNGSK-V323JHN-EUEO7U2-MP43WQZ"; };
                    "phone" = { id = "5ZJWJJU-UNRIIOM-FAOAEI3-SFDYZRS-KL64MUW-PUVDXYX-POIUTLP-B3VH3AG"; };
                    "server" = { id = "YOPRCA6-AFYUSFG-IWDAO5P-FD22Q2Z-QACENI2-QADPSNH-UDJR36C-PYHBUQC"; };
                    "thor" = { id = "ZU3IMAE-WYAKQOF-JQNATOI-EDEYAWR-O4X7SGU-3DC47BX-5FSRJUM-OEWEOQJ"; };
                };

                folders = {
                    "Music" = {
                        id = "7us1i-1qu93";
                        path = "/home/${user}/Music";
                        devices = [ "desktop" "laptop" "phone" "thor" ];
                        ignorePerms = false;
                    };

                    "Documents" = {
                        id = "Documents";
                        path = "/home/${user}/Documents";
                        devices = [ "desktop" "laptop" ];
                        ignorePerms = false;
                    };
                };
            };
        };
    };
}
