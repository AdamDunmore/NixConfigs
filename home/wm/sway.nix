{ lib, config, pkgs, colours, ... }:

let
    mod = "Mod4";
    cfg = config.settings.home.wm.sway;
    inherit (lib) mkIf;
in
{
    config = mkIf cfg.enable { 
        wayland.windowManager.sway = {
            enable = true;
            package = pkgs.swayfx;
            checkConfig = false; #Temporary fix for swayfx
            config = {
                keybindings = {
                    "${mod}+h" = "splith";
                    "${mod}+v" = "splitv";

                    "${mod}+Shift+s" = "move scratchpad";
                    "${mod}+s" = "scratchpad show";
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
                    { command = "${pkgs.swaysome}/bin/swaysome init 1"; }
                ];

                bars = [];

                window = {
                    titlebar = false;
                };
            };
        }; 
    };
}

