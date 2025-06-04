{ lib, config, pkgs, colours, ... }:

let
    mod = "Mod4";
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

