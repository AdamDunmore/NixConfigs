{ lib, config, pkgs, ... }:

let
    mod = "Mod4";
    colours = import ../../values/colours.nix;
    cfg = config.settings.home.wm.sway;
in
{
    config = lib.mkIf cfg.enable { 
        wayland.windowManager.sway = {
            enable = true;
            package = pkgs.swayfx;
            checkConfig = false; #Temporary fix for swayfx
            config = {
                # TODO test removing this
                input = {
                    "*" = {
                        # Keyboard
                        xkb_layout = "gb";

                        # Mouse
                        accel_profile = "flat";
                        
                    };

                    "10182:480:GXTP7863:00_27C6:01E0_Touchpad" = { 
                        click_method = "clickfinger";
                        natural_scroll = "enabled";
                        tap = "enabled";
                    };
                };

                modes = {
                    resize = {
                            Escape = "mode default";
                            Return = "mode default";
                            Up = "resize shrink height 20px";
                            Left = "resize grow width 20px";
                            Down = "resize grow height 20px";
                            Right = "resize shrink width 20px";

                    };
                };

                startup = [
                    { command = "${pkgs.waybar}/bin/waybar";}
                    # { command = "${pkgs.ags}/bin/ags"; }
                    { command = "${pkgs.wpaperd}/bin/wpaperd"; }
                    { command = "${pkgs.kanshi}/bin/kanshi"; }

                    { command = "${pkgs.swaysome}/bin/swaysome init 1"; }
                ];

                keybindings = {
                    "${mod}+Return" = "exec alacritty"; # TODO
                    "${mod}+Shift+Q" = "kill";
                    "${mod}+D" = "exec ${pkgs.wofi}/bin/wofi";
                    "${mod}+Shift+C" = "reload";
                    "${mod}+l" = "exec ${config.settings.home.wm.defaults.locker}/bin/hyprlock"; #TODO change
                    "${mod}+c" = "exec ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\"";
                    "${mod}+a" = "exec ${pkgs.ags}/bin/ags -t \"menu\"";

                    #Modes
                    "${mod}+R" = "mode \"resize\"";

                    #Movements
                    "${mod}+Left" = "focus Left";
                    "${mod}+Down" = "focus Down";
                    "${mod}+Up" = "focus Up";
                    "${mod}+Right" = "focus Right";

                    "${mod}+Shift+Left" = "move Left";
                    "${mod}+Shift+Down" = "move Down";
                    "${mod}+Shift+Up" = "move Up";
                    "${mod}+Shift+Right" = "move Right";
                    
                    #Workspaces
                    "${mod}+1" = "exec ${pkgs.swaysome}/bin/swaysome focus 1";
                    "${mod}+2" = "exec ${pkgs.swaysome}/bin/swaysome focus 2";
                    "${mod}+3" = "exec ${pkgs.swaysome}/bin/swaysome focus 3";
                    "${mod}+4" = "exec ${pkgs.swaysome}/bin/swaysome focus 4";
                    "${mod}+5" = "exec ${pkgs.swaysome}/bin/swaysome focus 5";
                    "${mod}+6" = "exec ${pkgs.swaysome}/bin/swaysome focus 6";
                    "${mod}+7" = "exec ${pkgs.swaysome}/bin/swaysome focus 7";
                    "${mod}+8" = "exec ${pkgs.swaysome}/bin/swaysome focus 8";
                    "${mod}+9" = "exec ${pkgs.swaysome}/bin/swaysome focus 9";

                    "${mod}+Shift+1" = "exec ${pkgs.swaysome}/bin/swaysome move 1";
                    "${mod}+Shift+2" = "exec ${pkgs.swaysome}/bin/swaysome move 2";
                    "${mod}+Shift+3" = "exec ${pkgs.swaysome}/bin/swaysome move 3";
                    "${mod}+Shift+4" = "exec ${pkgs.swaysome}/bin/swaysome move 4";
                    "${mod}+Shift+5" = "exec ${pkgs.swaysome}/bin/swaysome move 5";
                    "${mod}+Shift+6" = "exec ${pkgs.swaysome}/bin/swaysome move 6";
                    "${mod}+Shift+7" = "exec ${pkgs.swaysome}/bin/swaysome move 7";
                    "${mod}+Shift+8" = "exec ${pkgs.swaysome}/bin/swaysome move 8";
                    "${mod}+Shift+9" = "exec ${pkgs.swaysome}/bin/swaysome move 9";

                    "${mod}+h" = "splith";
                    "${mod}+v" = "splitv";
                    "${mod}+f" = "fullscreen";
                    "${mod}+Shift+f" = "floating toggle";

                    "${mod}+Shift+s" = "move scratchpad";
                    "${mod}+s" = "scratchpad show";

                    "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
                    "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
                    "XF86AudioMute" = "exec pactl set-sink-volume @DEFAULT_SINK@ 0%";
                    "XF86MonBrightnessUp" = "exec brightnessctl set 5%+";
                    "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
                };

                bars = [];

                gaps = {
                    inner = 10;
                    outer = 10;
                };


                window = {
                    border = 3;
                    titlebar = false;
                };

                colors = {
                    unfocused = {
                        background = "#00000000";
                        border = "#00000000";
                        childBorder = "${colours.blue.two}";
                        indicator = "#00000000";
                        text = "#00000000";
                    };
                    focused = {
                        background = "#00000000";
                        border = "#00000000";
                        childBorder = "${colours.blue.two}";
                        indicator = "${colours.blue.one}";
                        text = "#00000000";
                    };
                };

                floating = {
                    modifier = "${mod}";
                };
            };

            extraConfig = ''
                corner_radius 5
                default_dim_inactive 0.2
            '';
        }; 
    };
}

