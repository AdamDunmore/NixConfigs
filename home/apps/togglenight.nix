{ config, lib, pkgs, ... }:

let
    cfg = config.settings.home.apps.level;
    tn = pkgs.writeShellScriptBin "togglenight" "pgrep gammastep >/dev/null && pkill gammastep || nohup gammastep -O 17000K -b 0.3 &";

    inherit (lib) mkIf;
in
{
    config = mkIf (cfg == "all" || cfg == "light") {
        home.packages = [ tn ];
        xdg.desktopEntries.togglenight = {
            name = "tn";
            genericName = "Toggle Night";
            exec = "${tn}/bin/togglenight";
            terminal = false;
        }; 
    };
}
