{ pkgs, lib, config, ... }:
let
    cfg = config.settings.modules.home.apps.scripts;
    pc = pkgs.writeShellScriptBin "powercycle" ''
        profile="$(powerprofilesctl get)"

        if [[ $profile = "performance" ]]; then
            powerprofilesctl set power-saver
            new_profile=power-saver 
            icon=󱧥
        elif [[ $profile = "power-saver" ]]; then 
            powerprofilesctl set performance 
            new_profile=performance 
            icon=
        else
            new_profile=performance 
            icon=
        fi

        notify-send "$icon Power Profile Changed" "New profile: $new_profile" 
    '';
    inherit (lib) mkIf;
in
{
    config = mkIf cfg.enable {
        home.packages = [ pc ];
        xdg.desktopEntries.powercycle = {
            name = "pc";
            genericName = "Powercycle";
            exec = "${pc}/bin/powercycle";
            terminal = false;
        }; 
    };
}
