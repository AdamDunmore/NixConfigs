{ inputs, config, lib, local, pkgs, ... }:
let
    cfg = config.settings.nixos.steamdeck;
    defaults = config.settings.home.wm.defaults;
    inherit (lib) mkIf;
in
{
    imports = [ inputs.jovian.nixosModules.jovian ];
    config = mkIf cfg.enable {
        jovian = {
            decky-loader = {
                enable = true;
                user = local.username;

            };
            devices.steamdeck = {
                enable = true;
                autoUpdate = true;
            };
            steam = {
                autoStart = true;
                desktopSession = "${defaults.wm}/bin/${defaults.wm.meta.mainProgram}";
                enable = true;
                user = local.username;
            };
            steamos.useSteamOSConfig = true;
        }; 
    };
}
