{ pkgs, lib, config, ... }:
let
    cfg = config.settings.modules.home.apps.scripts;
    tn = pkgs.writeShellScriptBin "togglenight" ''
        pgrep gammastep >/dev/null && pkill gammastep || nohup gammastep -O 17000K -b 0.3 >/dev/null 2>&1 &
        path="/sys/class/leds/chromeos:white:power/brightness"
        echo $((1 - $(cat "$path"))) > "$path"
    '';
    inherit (lib) mkIf;
in
{
    config = mkIf cfg.enable {
        home.packages = [ tn ];
        xdg.desktopEntries.togglenight = {
            name = "tn";
            genericName = "Toggle Night";
            exec = "${tn}/bin/togglenight";
            terminal = false;
        }; 
    };
}
