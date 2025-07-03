{ lib, config, pkgs, ...}:

let
    cfg = config.settings.home.wm;
    forEachPkg = builtins.attrValues cfg.defaults;
    wm_keybinds = [
        {
            keys = [ "mod" "return" ];
            command = "exec";
            arg = "${cfg.defaults.terminal}/bin/${cfg.defaults.terminal.meta.mainProgram}";
        }
    ];
in
{
    imports = [
        ./hyprland.nix
        ./river.nix
        ./sway.nix

        ./lockers/hyprlock.nix
        ./lockers/swaylock.nix
    ];

    config = { 
        home.packages = forEachPkg;
        wayland.windowManager.sway.config.keybindings = let mod = "Mod4"; in {
            "${mod}+Return" = "exec ${(builtins.elemAt wm_keybinds 0).arg}";
            # "${mod}+Return" = "exec alacritty"; # TODO
            "${mod}+Shift+Q" = "kill";
            "${mod}+D" = "exec ${pkgs.wofi}/bin/wofi";
            "${mod}+Shift+C" = "reload";
            "${mod}+l" = "exec ${config.settings.home.wm.defaults.locker}/bin/hyprlock"; #TODO change
            "${mod}+c" = "exec ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\"";

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
