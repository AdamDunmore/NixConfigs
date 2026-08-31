{ pkgs, inputs, user, ... }: 

{
    imports = [ inputs.jovian.nixosModules.default ];

    config = {
        networking.hostName = "steam-deck";

        jovian = {
            hardware.has.amd.gpu = true;
            devices.steamdeck = {
                enable = true;
                autoUpdate = true;
            };
            decky-loader = {
                enable = true;
            };
            steamos.useSteamOSConfig = true;
            steam = {
                enable = true;
                inherit user;
                autoStart = true;
                # desktopSession = "mangowm";
            };
        }; 
    };
}
