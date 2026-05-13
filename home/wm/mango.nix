{ inputs, config, lib, pkgs, colours, ... }:
let
    mod = "SUPER";
    cfg = config.settings.home.wm.mango;
    hexToMango = c: builtins.replaceStrings ["#"] ["0x"] c;
    inherit (lib) mkIf;
in
{
    config = mkIf cfg.enable {
        wayland.windowManager.mango-ext = {
            enable = true;
            systemd.enable = true;
            settings = {
                enable_hotarea = 0;
                focus_cross_monitor = 1;
                exchange_cross_monitor = 1;
                scratchpad_cross_monitor = 1;
                circle_layout = "tile,canvas"; 

                bind = [
                    # Window Modes
                    "${mod}+Shift,N,switch_layout"

                    # Canvas
                    "${mod},Z,canvas_zoom_resize,1.1"
                    "${mod},X,canvas_zoom_resize,0.9"
                    
                    # Scratch
                    "${mod},S,toggle_scratchpad"
                    "${mod}+Shift,S,minimized"
                ];

                axisbind = [
                    "${mod},Up,canvas_zoom_resize,1.1"
                    "${mod},Down,canvas_zoom_resize,0.9"
                ];

                mousebind = [
                    "${mod},btn_right,canvas_drag_pan"
                    "${mod},btn_left,moveresize,curmove"
                ];

                keymode = {
                    resize = {
                        bind = [
                #             "NONE,Escape,setkeymode,default"
                            "NONE,Up,resizewin,0,-20" 
                            "NONE,Left,resizewin,-20,0" 
                            "NONE,Down,resizewin,0,20" 
                            "NONE,Right,resizewin,20,0" 
                        ];
                    };
                };

                # Window Rules
                windowrule = [
                    "unfocused_opacity:1.0,appid:firefox"
                ];

                # Monitors
                monitorrule="name:^eDP-1$,scale:2";
            };
        };
    };
}
