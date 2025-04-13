{ lib, config, pkgs, ... }:

let
    cfg = config.settings.home.wm.hyprland;
    defaults = config.settings.home.wm.defaults;
in
with lib;
{
    config = mkIf cfg.enable { 
        wayland.windowManager.hyprland = { 
            enable = true;
            package = pkgs.hyprland;
            settings = {
                "$mod" = "SUPER";

                exec = [
                    "${pkgs.wpaperd}/bin/wpaperd"
                    "${pkgs.waybar}/bin/waybar"
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

                bind = [
                    "$mod, Return, exec, ${defaults.terminal}/bin/${defaults.terminal.meta.mainProgram}"
                    "$mod_SHIFT, Q, killactive"
                    "$mod, D, exec, ${pkgs.wofi}/bin/wofi"
                    "$mod_SHIFT, C, exec, hyprctl reload"
                    "$mod, L, exec, ${defaults.locker}/bin/${defaults.locker.meta.mainProgram}"
                    "$mod, C, exec, ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\""

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

                    "$mod, H, togglesplit,"

                    "$mod, F, fullscreen, active"
                    "$mod_SHIFT, f, togglefloating, active"

                    "$mod, S, togglespecialworkspace, magic"
                    "$mod_SHIFT, S, movetoworkspace, special:magic"

                    ", XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%"
                    ", XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -5%"
                    ", XF86AudioMute, exec, pactl set-sink-volume @DEFAULT_SINK@ 0%"
                    ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
                    ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"

                    # Suspend on laptop close
                    ", switch:Lid Switch, exec, systemctl suspend"
                ];
            };
            extraConfig = ''
                bind = $mod, S, submap, resize
  
                submap = resize
                binde = , right, resizeactive, 20 0
                binde = , left, resizeactive, -20 0
                binde = , up, resizeactive, 0 -20
                binde = , down, resizeactive, 0 20
                bind = , escape, submap, reset
                submap = reset
            '';
        };
    };
}
