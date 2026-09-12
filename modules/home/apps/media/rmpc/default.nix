{ pkgs, config, lib, ... }:
let
    cfg = config.settings.modules.home.apps.media.rmpc;
    rmpcTheme = import ./theme.nix { inherit pkgs; colours = config.settings.values.colours; };
    inherit (lib) mkIf; 
in
{
    config = mkIf cfg.enable {
        programs.rmpc.enable = true;

        xdg.desktopEntries.rmpc = {
            name = "rmpc";
            genericName = "music";
            exec = "${config.settings.modules.home.wm.defaults.terminal}/bin/${config.settings.modules.home.wm.defaults.terminal.meta.mainProgram} -e ${pkgs.rmpc}/bin/rmpc";
            terminal = false;
        }; 

        home.file = {
            ".config/rmpc/config.ron".source = ./config.ron;
            ".config/rmpc/themes/theme.ron".source = rmpcTheme;
        };
    };
}

