{ lib, config, pkgs, ... }:
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

