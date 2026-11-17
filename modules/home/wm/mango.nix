{ config, lib, pkgs, ... }:
let
    mod = "SUPER";
    cfg = config.settings.modules.home.wm.mango;
    inherit (lib) mkIf;
in
{
    config = mkIf cfg.enable {
        wayland.windowManager.mango = {
            enable = true;
            systemd.enable = true;
            settings = {
                drag_tile_to_tile = 1;
                enable_hotarea = 0;
                focus_cross_monitor = 1;
                exchange_cross_monitor = 1;
                scratchpad_cross_monitor = 1;
                circle_layout = "tile"; 
                bind = [
                    # Window Modes
                    "${mod}+Shift,N,switch_layout"

                    # Scratch
                    "${mod},S,toggle_scratchpad"
                    "${mod}+Shift,S,minimized"
                ];

                mousebind = [
                    "${mod},btn_left,moveresize,curmove"
                ];

                # Window Rules
                window_rule = [ # Move to module?
                    "unfocused_opacity:1.0,app_id:firefox"
                    "unfocused_opacity:1.0,app_id:com.stremio.Stremio"
                ];

                # Monitors
                monitor_rule="name:^eDP-1$,scale:2";
            };
        };
    };
}

