{ config, lib, ... }:

let
    cfg = config.home.apps.autostart;
in
{
    config = lib.mkMerge [
        ( lib.mkIf cfg.autostart.enable {
            xdg.desktopEntries.autostart = 
            let
                packages = map (pkg: pkg + "/bin/${pkg.meta.mainProgram}") cfg.apps;
            in
            {
                name = "AS";
                genericName = "Autostart";
                exec = builtins.concatStringsSep " & " packages;
                terminal = false;
            }; 
        } )
    ];
}
