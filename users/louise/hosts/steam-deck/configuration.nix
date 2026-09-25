{ config, pkgs, lib, inputs, user, ... }: 
let
    inherit (lib) mkIf;
in
{
    imports = [ inputs.jovian.nixosModules.default ];

    config = {
        networking.hostName = "steam-deck";

        boot.loader.grub.efiSupport = true;

        users.users.${user}.password = "";
        services.displayManager= {
            defaultSession = "gamescope-wayland";
            autoLogin = {
                enable = true;
                inherit user;
            };
        };

        # Create Steam CEF debugging file if it doesn't exist for Decky Loader. 
        systemd.services.steam-cef-debug = mkIf config.jovian.decky-loader.enable {
            description = "Create Steam CEF debugging file";
            serviceConfig = {
                Type = "oneshot";
                User = config.jovian.steam.user;
                ExecStart = "/bin/sh -c 'mkdir -p ~/.steam/steam && [ ! -f ~/.steam/steam/.cef-enable-remote-debugging ] && touch ~/.steam/steam/.cef-enable-remote-debugging || true'";
            };
            wantedBy = [ "multi-user.target" ];
        };

        jovian = {
            hardware.has.amd.gpu = true;
            devices.steamdeck = {
                enable = true;
                autoUpdate = true;
                enableOsFanControl = false;
            };
            decky-loader = {
                enable = true;
            };
            steamos.useSteamOSConfig = true;
            steam = {
                enable = true;
                inherit user;
                autoStart = true;
                desktopSession = "sway";
            };
        }; 
    };
}
