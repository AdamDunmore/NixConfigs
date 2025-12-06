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
                    "laptop" = { id = "KIPS7XQ-OJUQDR7-QYSLXWJ-YMOM7NZ-H7PNGSK-V323JHN-EUEO7U2-MP43WQZ"; };
                    "phone" = { id = "SACQFTJ-WSNSYEW-TNPCSNC-RGUJFZU-DYP76PS-PWX5NJN-RCDISQP-Q63KWQZ"; };
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
