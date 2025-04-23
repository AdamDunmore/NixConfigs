{ inputs, config, lib, local, ... }:
let
    cfg = config.settings.nixos.steamdeck;
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
                enable = true;
                user = local.username;
            };
        }; 
    };
}
