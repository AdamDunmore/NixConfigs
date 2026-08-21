{ config, lib, pkgs, ... }:

let
    cfg = config.settings.modules.nixos.display_managers;
    inherit (lib) mkIf;
in
{
    config = mkIf (cfg.default == "ly") { 
        services.displayManager.ly = {
            enable = true;
            package = pkgs.ly;
            settings = {
                tty = 1; 
            };
        };
    };
}
