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
                    # Modes
                    "${mod},R,setkeymode,resize"

                    # Movements
                    "${mod},Left,focusdir,left"
                    "${mod},Down,focusdir,down"
                    "${mod},Up,focusdir,up"
                    "${mod},Right,focusdir,right"

                    "${mod}+Shift,Left,exchange_client,left"
                    "${mod}+Shift,Down,exchange_client,down"
                    "${mod}+Shift,Up,exchange_client,up"
                    "${mod}+Shift,Right,exchange_client,right"

                    # Workspaces
                    "${mod},1,view,1"
                    "${mod},2,view,2"
                    "${mod},3,view,3"
                    "${mod},4,view,4"
                    "${mod},5,view,5"
                    "${mod},6,view,6"
                    "${mod},7,view,7"
                    "${mod},8,view,8"
                    "${mod},9,view,9"

                    "${mod}+Shift,1,tagsilent,1"
                    "${mod}+Shift,2,tagsilent,2"
                    "${mod}+Shift,3,tagsilent,3"
                    "${mod}+Shift,4,tagsilent,4"
                    "${mod}+Shift,5,tagsilent,5"
                    "${mod}+Shift,6,tagsilent,6"
                    "${mod}+Shift,7,tagsilent,7"
                    "${mod}+Shift,8,tagsilent,8"
                    "${mod}+Shift,9,tagsilent,9"

                    # Window Modes
                    "${mod}+Shift,N,switch_layout"
                    "${mod},F,togglefloating"
                    "${mod}+Shift,F,togglefullscreen"

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
                            "NONE,Escape,setkeymode,default"
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
