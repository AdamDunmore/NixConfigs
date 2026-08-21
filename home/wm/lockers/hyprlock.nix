{ config, lib, pkgs, colours, ... }:
let
    cfg = config.settings.home.wm.hyprland;
in
{
    config = lib.mkIf cfg.hyprlock {
        programs.hyprlock = { 
            enable = true;
            package = pkgs.hyprlock;
            settings = {
                general = {
                    disable_loading_bar = false;
                    hide_cursor = true;
                    no_fade_in = false;
                };
                background = [
                    {
                        color = colours.blue.one;
                        blur_passes = 3;
                        blur_size = 8;
                    }
                ];
                label = [
                  {
                    size = "500, 200";
                    position = "0, 200";
                    monitor = "";
                    text = "Locked";
                    font_size = 50;
                    color = colours.white.one;
                    halign = "center";
                    valign = "center";
                  }
                ];
                input-field = [
                    {
                        size = "200, 50";
                        position = "0, -80";
                        monitor = "";
                        dots_center = true;
                        fade_on_empty = false;
                        font_color = "rgb(202, 211, 245)";
                        inner_color = "rgb(91, 96, 120)";
                        outer_color = "rgb(24, 25, 38)";
                        outline_thickness = 5;
                        placeholder_text = "<span foreground=\"##cad3f5\">Password...</span>";
                        shadow_passes = 2;
                    }
                ];
            };
        };
    };
}
