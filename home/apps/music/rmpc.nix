{ pkgs, config, lib, ... }:
let
    cfg = config.settings.home.apps.music; 
    inherit (lib) mkIf; 
in
{
    config = mkIf cfg.enable {
        programs.rmpc.enable = true;

        xdg.desktopEntries.rmpc = {
            name = "rmpc";
            genericName = "music";
            exec = "${pkgs.alacritty}/bin/alacritty -e ${pkgs.rmpc}/bin/rmpc";
            terminal = false;
        }; 

        home.file = {
            ".config/rmpc/config.ron".source = ./config.ron;
            ".config/rmpc/themes/nord_mini.ron".source = ./themes/nord_mini.ron;
        };
    };
}
