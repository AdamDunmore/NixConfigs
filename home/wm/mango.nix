{ inputs, config, lib, pkgs, colours, ... }:
let
    mod = "SUPER";
    cfg = config.settings.home.wm.mango;
    hexToMango = c: builtins.replaceStrings ["#"] ["0x"] c;
    inherit (lib) mkIf;
in
{
    imports = [ inputs.mango.hmModules.mango ];
    config = mkIf cfg.enable {
        wayland.windowManager.mango = {
            enable = true;
            settings = {
                enable_hotarea = 0;
                focus_cross_monitor = 1;
                exchange_cross_monitor = 1;
                scratchpad_cross_monitor = 1;
                circle_layout = "tile,canvas";

                exec-once = [
                    "${pkgs.wpaperd}/bin/wpaperd"
                    "${pkgs.kanshi}/bin/kanshi"
                    (mkIf (config.settings.home.wm.replays) "${pkgs.gpu-screen-recorder}/bin/gpu-screen-recorder -w ${config.settings.home.wm.primary-monitor} -c mp4 -r 300 -restart-replay-on-save yes -o ~/Videos/Replays") 
                    "ags run"
                    "${pkgs.waybar}/bin/waybar" # Waybar doesnt get started because mango doesn't reach graphical-session.target
                    "${pkgs.rmpc}/bin/rmpc play" # Pretty sure its the same issue as above
                ];

                bind = [
                    "${mod},Return,spawn,${config.settings.home.wm.defaults.terminal}/bin/${config.settings.home.wm.defaults.terminal.meta.mainProgram}"
                    "${mod}+Shift,Q,killclient"
                    "${mod},D,spawn,${pkgs.wofi}/bin/wofi"
                    "${mod}+Shift,C,reload_config"
                    "${mod},L,spawn,${config.settings.home.wm.defaults.locker}/bin/${config.settings.home.wm.defaults.locker.meta.mainProgram}"
                    "${mod},C,spawn,GRIM_DEFAULT_DIR=~/Pictures/Screenshots ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\"" #TODO fix
                    (mkIf config.settings.home.widgets.ags "${mod},Q,spawn,ags toggle sidebar")
                    "${mod},B,spawn,btwofi" #TODO fix
                    "${mod},N,spawn,togglenight"
                    "${mod},T,spawn,translate"
                    (mkIf config.settings.home.wm.replays "${mod}+Shift,R,spawn,killall -SIGUSR1 gpu-screen-recorder && notify-send \"Replay Saved\"") #TODO fix                     
                    
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

                    # Media
                     "NONE,XF86AudioRaiseVolume,spawn,pactl set-sink-volume @DEFAULT_SINK@ +5%"
                     "NONE,XF86AudioLowerVolume,spawn,pactl set-sink-volume @DEFAULT_SINK@ -5%"
                     "NONE+Shift,XF86AudioRaiseVolume,spawn,pactl set-sink-volume @DEFAULT_SINK@ +1%"
                     "NONE+Shift,XF86AudioLowerVolume,spawn,pactl set-sink-volume @DEFAULT_SINK@ -1%"
                     "NONE,XF86AudioMute,spawn,pactl set-sink-volume @DEFAULT_SINK@ 0%"
                    
                     "NONE,XF86MonBrightnessUp,spawn,brightnessctl set 5%+"
                     "NONE,XF86MonBrightnessDown,spawn,brightnessctl set 5%-"
                     "NONE+Shift,XF86MonBrightnessUp,spawn,brightnessctl set 1%+"
                     "NONE+Shift,XF86MonBrightnessDown,spawn,brightnessctl set 1%-"
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

                # Keyboard
                xkb_rules_layout="gb";

                # Mouse
                accel_profile=1;
                
                #Trackpad
                trackpad_natural_scrolling = 1;
                tap_to_click = 1;

                # Apperance
                border_radius = 5;
                unfocused_opacity = 0.8;
                borderpx = 3;
                smartgaps = 1;
                no_border_when_single = 1;

                gappih = 5;
                gappiv = 5;
                gappoh = 2;
                gappov = 2;

                bordercolor = hexToMango colours.blue.two;
                focuscolor = hexToMango colours.blue.three;

                # Monitors
                monitorrule="name:^eDP-1$,scale:2";
            };
        };
    };
}
