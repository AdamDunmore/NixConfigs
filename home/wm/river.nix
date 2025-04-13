{ lib, config, pkgs, ... }:

# TODO fix river tags

let
    cfg = config.settings.home.wm.river;
    defaults = config.settings.home.wm.defaults;
    mod = "Super";
in
with lib;
{
  config = mkMerge [
    ( mkIf cfg.enable { 
        wayland.windowManager.river = {
            enable = true;
            package = pkgs.river;
            systemd.enable = true;
            settings = {
                default-layout = "rivertile";
                keyboard-layout = "gb";
                set-focused-tags = "1";
                declare-mode = [
                    "normal"
                    "resize"
                ];
                spawn = [
                    "${pkgs.waybar}/bin/waybar"
                    "${pkgs.wpaperd}/bin/wpaperd"
                    "${pkgs.kanshi}/bin/kanshi"
                    "${pkgs.river}/bin/rivertile" 
                    # "riverctl set-focused-tags 000000001";
                ];
                map = {
                    normal = {
                        "${mod} Return" = "spawn ${defaults.terminal}/bin/${defaults.terminal.meta.mainProgram}";
                        "${mod}+Shift Q" = "close";
                        "${mod} D" = "spawn ${pkgs.wofi}/bin/wofi";
                        "${mod} L" = "spawn ${defaults.locker}/bin/${defaults.locker.meta.mainProgram}";
                        "${mod} C" = "spawn ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\""; 

                        "${mod}+Shift F" = "toggle-float";
                        "${mod} F" = "toggle-fullscreen";

                        "${mod} R" = "enter-mode resize";

                        "${mod} Left" = "focus-view left";
                        "${mod} Up" = "focus-view up";
                        "${mod} Right" = "focus-view right";
                        "${mod} Down" = "focus-view down";

                        "${mod}+Shift Left" = "swap left";
                        "${mod}+Shift Up" = "swap up";
                        "${mod}+Shift Right" = "swap right";
                        "${mod}+Shift Down" = "swap down";

                        "${mod} 1" = "set-focused-tags 000000001";
                        "${mod} 2" = "set-focused-tags 000000010";
                        "${mod} 3" = "set-focused-tags 000000100";
                        "${mod} 4" = "set-focused-tags 000001000";
                        "${mod} 5" = "set-focused-tags 000010000";
                        "${mod} 6" = "set-focused-tags 000100000";
                        "${mod} 7" = "set-focused-tags 001000000";
                        "${mod} 8" = "set-focused-tags 010000000";
                        "${mod} 9" = "set-focused-tags 100000000";
                        
                        "${mod}+Shift 1" = "set-view-tags 000000001";
                        "${mod}+Shift 2" = "set-view-tags 000000010";
                        "${mod}+Shift 3" = "set-view-tags 000000100";
                        "${mod}+Shift 4" = "set-view-tags 000001000";
                        "${mod}+Shift 5" = "set-view-tags 000010000";
                        "${mod}+Shift 6" = "set-view-tags 000100000";
                        "${mod}+Shift 7" = "set-view-tags 001000000";
                        "${mod}+Shift 8" = "set-view-tags 010000000";
                        "${mod}+Shift 9" = "set-view-tags 100000000";
                    };
                };
            };
        }; 
    })
  ];
}
