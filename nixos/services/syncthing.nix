{ lib, config, primary-user, ... }:

# TODO move to hm
let
    cfg = config.settings.nixos.services.syncthing;
    inherit (lib) mkIf;
in
{
    config = mkIf cfg {    
        services.syncthing = {
            enable = true;
            user = primary-user;
            dataDir = "/home/${primary-user}/";
            configDir = "/home/${primary-user}/.config/syncthing";
            overrideFolders = true;
            overrideDevices = true;

            settings = {
                devices = {
                    "desktop" = { id = "DIZXZOG-IIRYVVX-F2IYNJH-HD6TZNG-VCKQULR-PVNGL7Z-7HMA4KN-ZF66RAU"; };
                    "laptop" = { id = "NLP3QWK-JRKA3NV-WOEUVOW-RO36YLY-V5WIF7U-LHY7BBC-XAVMZF3-BW5F2AR"; };
                    "phone" = { id = "5NTRRMM-VISZNNG-7Q5KQQT-VEA5OBC-6BNUADV-WL6FIZM-XB5TNRW-KRV2YQS"; };
                    "server" = { id = "YOPRCA6-AFYUSFG-IWDAO5P-FD22Q2Z-QACENI2-QADPSNH-UDJR36C-PYHBUQC"; };
                };

                folders = {
                    "Music" = {
                        id = "7us1i-1qu93";
                        path = "/home/${primary-user}/Music";
                        devices = [ "desktop" "laptop" "phone" ];
                        ignorePerms = false;
                    };

                    "Documents" = {
                        id = "Documents";
                        path = "/home/${primary-user}/Documents";
                        devices = [ "desktop" "laptop" ];
                        ignorePerms = false;
                    };
                };
            };
        };
    };
}
