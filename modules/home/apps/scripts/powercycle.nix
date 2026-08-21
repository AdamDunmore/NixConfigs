{ pkgs, lib, config, ... }:
let
    cfg = config.settings.modules.home.apps.scripts;
    pc = pkgs.writeShellScriptBin "powercycle" ''
        profile="$(powerprofilesctl get)"

        if [[ $profile = "performance" ]]; then
            powerprofilesctl set power-saver
            new_profile=power-saver 
        elif [[ $profile = "power-saver" ]]; then 
            powerprofilesctl set performance 
            new_profile=performance 
        else
            new_profile=performance 
        fi

        notify-send "Power Profile Changed" $new_profile 
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
