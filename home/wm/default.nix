{ lib, config, pkgs, ...}:

let
    cfg = config.settings.home.wm;
    forEachPkg = builtins.attrValues cfg.defaults;
    wm_keybinds = [
        {
            keys = [ "mod" "return" ];
            command = "exec";
            arg = "";
        }
    ];

    get_bind = builtins.elemAt wm_keybinds;
in
{
    imports = [
        ./cosmic.nix
        ./hyprland.nix
        ./river.nix
        ./sway.nix

        ./lockers/hyprlock.nix
        ./lockers/swaylock.nix
    ];

    config = { 
        home.packages = forEachPkg;
    };
}
# WM Config Template 

# Startup
# - bar
# - wallpaper
# - monitor service
# - multi-monitor support

# Resize Mode
# - Escape = default mode
# - Return = default mode
# - Up, Left, Right, Down = resize 20px 

# Keybinds
# - mod + return = start terminal
# - mod + shift + q = kill focused
# - mod + d = start app menu
# - mod + shift + c = reload
# - mod + l = lock
# - mod + c = screenshot

# - mod + r = resize mode

# - mod + left = focus left
# - mod + right = focus right
# - mod + up = focus up
# - mod + down = focus down

# - mod + shift + left = move left
# - mod + shift + right = move right
# - mod + shift + up = move up
# - mod + shift + down = move down

# - mod + num = focus workspace num
# - mod + shift + num = move focused to workspace num

# - mod + h = horizontal split
# - mod + v = vertical split

# - mod + f = fullscreen focused
# - mod + shift + f = toggle focused floating

# - mod + s = show scratchpad
# - mod + shift + s = move to scratchpad


# - XF86AudioRaiseVolume = pactl set-sink-volume @DEFAULT_SINK@ +5%
# - XF86AudioLowerVolume = pactl set-sink-volume @DEFAULT_SINK@ -5%
# - XF86AudioMute = pactl set-sink-volume @DEFAULT_SINK@ 0%
# - XF86MonBrightnessUp = brightnessctl set 5%+
# - XF86MonBrightnessDown = brightnessctl set 5%-
