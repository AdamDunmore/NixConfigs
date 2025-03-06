{ lib, config, pkgs, ... }:

let
  cfg = config.settings.home.wm.river;
  riverConfig = {
        enable = true;
        package = pkgs.river;
        systemd.enable = true;
        settings = {
            default-layout = "rivertile";
            keyboard-layout = "gb";
            set-focused-tags = "1";
            declare-mode = [
                "normal"
                "locked"
            ];
            spawn = [
                "${pkgs.ags}/bin/ags" 
                "${pkgs.kanshi}/bin/kanshi"
                "${pkgs.wpaperd}/bin/wpaperd"
                "${pkgs.river}/bin/rivertile" 
            ];
            map = {
                normal = {
                    "Super+Shift Q" = "close";
                    "Super+Shift F" = "toggle-float";
                    "Super F" = "toggle-fullscreen";

                    
                    "Super Return" = "spawn ${config.adam.terminal.terminals.default}";
                    "Super D" = "spawn ${pkgs.wofi}/bin/wofi";

                    "Super Left" = "focus-view left";
                    "Super Up" = "focus-view up";
                    "Super Right" = "focus-view right";
                    "Super Down" = "focus-view down";

                    "Super+Shift Left" = "swap left";
                    "Super+Shift Up" = "swap up";
                    "Super+Shift Right" = "swap right";
                    "Super+Shift Down" = "swap down";

                    "Super 0" = "set-focused-tags 0000000001";
                    "Super 1" = "set-focused-tags 0000000010";
                    "Super 2" = "set-focused-tags 0000000100";
                    "Super 3" = "set-focused-tags 0000001000";
                    "Super 4" = "set-focused-tags 0000010000";
                    "Super 5" = "set-focused-tags 0000100000";
                    "Super 6" = "set-focused-tags 0001000000";
                    "Super 7" = "set-focused-tags 0010000000";
                    "Super 8" = "set-focused-tags 0100000000";
                    "Super 9" = "set-focused-tags 1000000000";
                    
                    "Super+Shift 0" = "set-view-tags 0000000001";
                    "Super+Shift 1" = "set-view-tags 0000000010";
                    "Super+Shift 2" = "set-view-tags 0000000100";
                    "Super+Shift 3" = "set-view-tags 0000001000";
                    "Super+Shift 4" = "set-view-tags 0000010000";
                    "Super+Shift 5" = "set-view-tags 0000100000";
                    "Super+Shift 6" = "set-view-tags 0001000000";
                    "Super+Shift 7" = "set-view-tags 0010000000";
                    "Super+Shift 8" = "set-view-tags 0100000000";
                    "Super+Shift 9" = "set-view-tags 1000000000";
                };
            };
        };
    };

in
with lib;
{
  config = mkMerge [
    ( mkIf cfg.enable { wayland.windowManager.river = riverConfig; })
  ];
}
