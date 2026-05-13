{ lib, config, pkgs, colours, inputs, ...}:

let
    cfg = config.settings.home.wm;
    forEachPkg = builtins.attrValues cfg.defaults;
    
    inherit (lib) mkIf;
in
{
    imports = [
        ./module.nix

        ./hyprland.nix
        ./river.nix
        ./mango.nix
        ./sway.nix

        ./lockers/hyprlock.nix
        ./lockers/swaylock.nix

        inputs.mango.hmModules.mango-ext
    ];

    config = { 
        wm = {
            modifier = "SUPER";
            keybinds = [
                { mod = true; key = "Return"; dispatch = "spawn"; arg = "${config.settings.home.wm.defaults.terminal}/bin/${config.settings.home.wm.defaults.terminal.meta.mainProgram}"; }
                { mod = true; sub_mod = "SHIFT"; key = "Q"; dispatch = "kill"; }
                { mod = true; key = "D"; dispatch = "spawn"; arg = "${pkgs.wofi}/bin/wofi"; }
                { mod = true; sub_mod = "SHIFT"; key = "C"; dispatch = "reload"; }
                { mod = true; key = "L"; dispatch = "spawn"; arg = "${config.settings.home.wm.defaults.locker}/bin/${config.settings.home.wm.defaults.locker.meta.mainProgram}"; }
                { mod = true; key = "N"; dispatch = "spawn"; arg = "togglenight"; }
                { mod = true; key = "C"; dispatch = "spawn_shell"; arg = "GRIM_DEFAULT_DIR=~/Pictures/Screenshots ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\""; }
                { mod = true; key = "B"; dispatch = "spawn_shell"; arg = "btwofi"; }
                { mod = true; key = "T"; dispatch = "spawn_shell"; arg = "translate"; } # Broken
                (mkIf config.settings.home.widgets.ags { mod = true; key = "Q"; dispatch = "spawn"; arg = "ags toggle sidebar"; })
                (mkIf config.settings.home.wm.replays { mod = true; sub_mod = "SHIFT"; key = "R"; dispatch = "spawn_shell"; arg = "killall -SIGUSR1 gpu-screen-recorder && notify-send \"Replay Saved\""; })

                { mod = true; key = "Left"; dispatch = "focus"; arg = "left"; }
                { mod = true; key = "Down"; dispatch = "focus"; arg = "down"; }
                { mod = true; key = "Up"; dispatch = "focus"; arg = "up"; }
                { mod = true; key = "Right"; dispatch = "focus"; arg = "right"; }

                { mod = true; sub_mod = "SHIFT"; key = "Left"; dispatch = "move"; arg = "left"; }
                { mod = true; sub_mod = "SHIFT"; key = "Down"; dispatch = "move"; arg = "down"; }
                { mod = true; sub_mod = "SHIFT"; key = "Up"; dispatch = "move"; arg = "up"; }
                { mod = true; sub_mod = "SHIFT"; key = "Right"; dispatch = "move"; arg = "right"; }

                { mod = true; key = "1"; dispatch = "view_workspace"; arg = "1"; }
                { mod = true; key = "2"; dispatch = "view_workspace"; arg = "2"; }
                { mod = true; key = "3"; dispatch = "view_workspace"; arg = "3"; }
                { mod = true; key = "4"; dispatch = "view_workspace"; arg = "4"; }
                { mod = true; key = "5"; dispatch = "view_workspace"; arg = "5"; }
                { mod = true; key = "6"; dispatch = "view_workspace"; arg = "6"; }
                { mod = true; key = "7"; dispatch = "view_workspace"; arg = "7"; }
                { mod = true; key = "8"; dispatch = "view_workspace"; arg = "8"; }
                { mod = true; key = "9"; dispatch = "view_workspace"; arg = "9"; }

                { mod = true; sub_mod = "SHIFT"; key = "1"; dispatch = "move_workspace"; arg = "1"; }
                { mod = true; sub_mod = "SHIFT"; key = "2"; dispatch = "move_workspace"; arg = "2"; }
                { mod = true; sub_mod = "SHIFT"; key = "3"; dispatch = "move_workspace"; arg = "3"; }
                { mod = true; sub_mod = "SHIFT"; key = "4"; dispatch = "move_workspace"; arg = "4"; }
                { mod = true; sub_mod = "SHIFT"; key = "5"; dispatch = "move_workspace"; arg = "5"; }
                { mod = true; sub_mod = "SHIFT"; key = "6"; dispatch = "move_workspace"; arg = "6"; }
                { mod = true; sub_mod = "SHIFT"; key = "7"; dispatch = "move_workspace"; arg = "7"; }
                { mod = true; sub_mod = "SHIFT"; key = "8"; dispatch = "move_workspace"; arg = "8"; }
                { mod = true; sub_mod = "SHIFT"; key = "9"; dispatch = "move_workspace"; arg = "9"; }

                { mod = true; key = "F"; dispatch = "fullscreen"; }
                { mod = true; sub_mod = "SHIFT"; key = "F"; dispatch = "floating"; }

                { mod = true; key = "R"; dispatch = "mode"; arg = "resize"; }

                { mod = false; key = "XF86AudioRaiseVolume"; dispatch = "spawn"; arg = "pactl set-sink-volume @DEFAULT_SINK@ +5%"; }
                { mod = false; key = "XF86AudioLowerVolume"; dispatch = "spawn"; arg = "pactl set-sink-volume @DEFAULT_SINK@ -5%"; }
                { mod = false; sub_mod = "SHIFT"; key = "XF86AudioRaiseVolume"; dispatch = "spawn"; arg = "pactl set-sink-volume @DEFAULT_SINK@ +1%"; }
                { mod = false; sub_mod = "SHIFT"; key = "XF86AudioLowerVolume"; dispatch = "spawn"; arg = "pactl set-sink-volume @DEFAULT_SINK@ -1%"; }
                { mod = false; key = "XF86AudioMute"; dispatch = "spawn"; arg = "pactl set-sink-volume @DEFAULT_SINK@ 0%"; }
                { mod = false; key = "XF86MonBrightnessUp"; dispatch = "spawn"; arg = "brightnessctl set 5%+"; }
                { mod = false; key = "XF86MonBrightnessDown"; dispatch = "spawn"; arg = "brightnessctl set 5%-"; }
                { mod = false; sub_mod = "SHIFT"; key = "XF86MonBrightnessUp"; dispatch = "spawn"; arg = "brightnessctl set 1%+"; }
                { mod = false; sub_mod = "SHIFT"; key = "XF86MonBrightnessDown"; dispatch = "spawn"; arg = "brightnessctl set 1%-"; }
            ];

            modes = [
                { 
                    name = "resize";
                    keybinds = [
                        { mod = false; key = "Escape"; dispatch = "mode"; arg = "default"; }
                        { mod = false; key = "Up"; dispatch = "resizev"; arg = "-20"; }
                        { mod = false; key = "Down"; dispatch = "resizev"; arg = "20"; }
                        { mod = false; key = "Left"; dispatch = "resizeh"; arg = "-20"; }
                        { mod = false; key = "Right"; dispatch = "resizeh"; arg = "20"; }
                    ];
                }
            ];

            input = {
                keyboard = {
                    layout = "gb";
                };
                mouse = {
                    accel = false;
                    tap = true;
                    natural_scroll = true;
                };
            };
            gaps = {
                inner = 5;
                outer = 2;
                smartGaps = true;
                smartBorders = true;
            };

            startup = [
                "${pkgs.wpaperd}/bin/wpaperd"
                "${pkgs.kanshi}/bin/kanshi"
                "ags run"
            ];

            startup_always = [
                ( mkIf (config.settings.home.wm.replays) "${pkgs.gpu-screen-recorder}/bin/gpu-screen-recorder -w ${config.settings.home.wm.primary-monitor} -c mp4 -r 300 -restart-replay-on-save yes -o ~/Videos/Replays")
            ];

            colours = {
                focused = {
                    border = "${colours.blue.two}";
                    indicator = "${colours.blue.one}";
                };
                unfocused = {
                    border = "${colours.blue.two}";
                };
            };

            window = {
                border = 3;
                border_radius = 5;
                dim = {
                    inactive = 0.8;
                };
            };
        };

        # Grim setup
        home.activation.createScreenshotsDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
            mkdir -p "$HOME/Pictures/Screenshots"
        ''; 

        home.sessionVariables = {
            GRIM_DEFAULT_DIR  = "~/Pictures/Screenshots";
        };
        
        # Replay setup
        home.activation.createReplayDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
            mkdir -p "$HOME/Videos/Replays"
        '';

        home.packages = forEachPkg ++ (with pkgs; [
            eog 
        ]);

        home.pointerCursor = {
            enable = true;
            name = "Adwaita";
            size = 16;
            package = pkgs.adwaita-icon-theme;

            gtk.enable = true;
            sway.enable = mkIf (cfg.sway.enable) true;
        };

        xdg = mkIf true {
            mime.enable = true;
            mimeApps = {
                enable = true;
                defaultApplications = {
                    "text/html" = [ "firefox.desktop" ];
                    "x-scheme-handler/http" = [ "firefox.desktop" ];
                    "x-scheme-handler/https" = [ "firefox.desktop" ];
                    "x-scheme-handler/about" = [ "firefox.desktop" ];
                    "x-scheme-handler/unknown" = [ "firefox.desktop" ];

                    "image/*" = [ "org.gnome.eog.desktop" "firefox.desktop" ];
                    "image/png" = [ "org.gnome.eog.desktop" "firefox.desktop" ];
                    "image/jpeg" = [ "org.gnome.eog.desktop" "firefox.desktop" ];
                    "image/gif" = [ "org.gnome.eog.desktop" "firefox.desktop" ];
                    "image/webp" = [ "org.gnome.eog.desktop" "firefox.desktop" ];
                    "image/bmp" = [ "org.gnome.eog.desktop" "firefox.desktop" ];
                    "image/tiff" = [ "org.gnome.eog.desktop" "firefox.desktop" ];
                    "image/svg+xml" = [ "org.gnome.eog.desktop" "firefox.desktop" ];

                    "video/*" = [ "mpv.desktop" "firefox.desktop" ];
                    "video/mp4" = [ "mpv.desktop" "firefox.desktop" ];
                };
            };
        };
    };
}
