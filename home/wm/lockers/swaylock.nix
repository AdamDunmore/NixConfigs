{ lib, config, pkgs, ... }:
let
    cfg = config.settings.home.wm.sway;
    colours = import ../../../values/colours.nix;
in
{
    config = lib.mkIf cfg.swaylock {
        programs.swaylock = {
            enable = true;
            package = pkgs.swaylock-effects;
            settings = {
                ignore-empty-password = true;
                
                clock = true;
                timestr = "%R";
                datestr = "%a, %e of %B";

                effect-blur="7x5";
                effect-vignette="0.5:0.5";

                color = colours.blue.one;
                line-color = "00000000";
                ring-color = "333355CC";
                key-hl-color = "555577EE";
                separator-color = "00000010";
                inside-color = "00000060";
                text-color = "FFFFFFAA";

                indicator = true;
                indicator-thickness = 15;
                indicator-radius = 150;
            };
        };     
    };
}
