{ lib, config, pkgs, ... }:

let
    cfg = config.settings.home.wm.hyprland;
    colours = import ../../../../values/colours.nix;
    hyprlandConfig = {
        enable = true;
        package = pkgs.hyprland;
        settings = {
            "$mod" = "SUPER";
            bind = [
              "$mod, Return, exec, ${config.adam.terminal.terminals.default}"
                "$mod, D, exec, ${pkgs.wofi}/bin/wofi"

                "$mod, F, fullscreen, active"
                "$mod_SHIFT, f, togglefloating, active"

                "$mod_SHIFT, Q, killactive"
                "$mod, H, togglesplit,"
                "$mod_SHIFT, C, exec, hyprctl reload"
                "$mod, L, exec, ${config.adam.wm.window_managers.default_locker}"
                "$mod, C, exec, ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\""
                "$mod, A, exec, ${pkgs.ags}/bin/ags -t \"menu\""

                "$mod, S, togglespecialworkspace, magic"
                "$mod_SHIFT, S, movetoworkspace, special:magic"

                "$mod, left, movefocus, l"
                "$mod, up, movefocus, u"
                "$mod, down, movefocus, d"
                "$mod, right, movefocus, r"

                "$mod_SHIFT, left, movewindow, l"
                "$mod_SHIFT, up, movewindow, u"
                "$mod_SHIFT, down, movewindow, c"
                "$mod_SHIFT, right, movewindow, r"

                "$mod, 1, workspace, 1"
                "$mod, 2, workspace, 2"
                "$mod, 3, workspace, 3"
                "$mod, 4, workspace, 4"
                "$mod, 5, workspace, 5"
                "$mod, 6, workspace, 6"
                "$mod, 7, workspace, 7"
                "$mod, 8, workspace, 8"
                "$mod, 9, workspace, 9"

                "$mod_SHIFT, 1, movetoworkspace, 1"
                "$mod_SHIFT, 2, movetoworkspace, 2"
                "$mod_SHIFT, 3, movetoworkspace, 3"
                "$mod_SHIFT, 4, movetoworkspace, 4"
                "$mod_SHIFT, 5, movetoworkspace, 5"
                "$mod_SHIFT, 6, movetoworkspace, 6"
                "$mod_SHIFT, 7, movetoworkspace, 7"
                "$mod_SHIFT, 8, movetoworkspace, 8"
                "$mod_SHIFT, 9, movetoworkspace, 9"

                "$mod_ALT, left, resizeactive, -10 0"
                "$mod_ALT, up, resizeactive, 0 10"
                "$mod_ALT, right, resizeactive, 10 0"
                "$mod_ALT, down, resizeactive, 0 -10"

                ", XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%"
                ", XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -5%"
                ", XF86AudioMute, exec, pactl set-sink-volume @DEFAULT_SINK@ 0%"
                ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
                ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"

                # Suspend on laptop close
                ", switch:Lid Switch, exec, systemctl suspend"
            ];
            exec = [
                "${pkgs.wpaperd}/bin/wpaperd"
                "${pkgs.ags}/bin/ags"
                "${pkgs.kanshi}/bin/kanshi"
            ];
            general = {
                gaps_in = 5;
                gaps_out = 10;

                border_size = 2;

                resize_on_border = true;
                layout = "dwindle";

                monitor = [
                    ",preferred,auto,1"
                ];
            };
            decoration = {
                rounding = 5;
                
                active_opacity = 1.0;
                inactive_opacity = 0.8;
            };
            input = {
                kb_layout = "gb";
                touchpad = {
                    natural_scroll = true;
                };
            };
            gestures = {
                workspace_swipe = true;
                workspace_swipe_fingers = 3;
            };
        };
    };
    hyprlockConfig = {
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


in
with lib;
{
  config = mkMerge [
    (mkIf cfg.enable { wayland.windowManager.hyprland = hyprlandConfig; })
    (mkIf cfg.hyprlock { programs.hyprlock = hyprlockConfig; })
  ];
}
