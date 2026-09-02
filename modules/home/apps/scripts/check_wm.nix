{ pkgs, lib, config, user, inputs, ... }:
let
    cfg = config.settings.modules.home.apps.scripts;
    waybar = import ../../../../pkgs/waybar.nix { inherit pkgs; inherit inputs; };
    cw = pkgs.writeShellScriptBin "check_wm" ''
        bins=("waybar" "ags" "kanshi" "wpaperd")
        commands=("${waybar}/bin/waybar" "/etc/profiles/per-user/${user}/bin/ags run" "${pkgs.kanshi}/bin/kanshi" "${pkgs.wpaperd}/bin/wpaperd")

        for i in "''${!commands[@]}"; do
            output=$(ps -A | grep ''${bins[i]})
            if [[ -z "$output" ]]; then
                echo "Starting ''${bins[i]}"
                eval "''${commands[i]}" & 
            else
                echo "Service Running fine: $output"
            fi
        done
    '';
    inherit (lib) mkIf;
in
{
    config = mkIf cfg.enable {
        home.packages = [ cw ];
        xdg.desktopEntries.check_wm = {
            name = "cw";
            genericName = "CheckWm";
            exec = "${cw}/bin/check_wm";
            terminal = false;
        }; 
    };
}
