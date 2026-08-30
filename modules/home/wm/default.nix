{ lib, config, pkgs, inputs, ...}:

let
    cfg = config.settings.modules.home.wm;
    cfg_ags = config.settings.modules.home.wm.shell.ags;
    colours = config.settings.values.colours;
    forEachPkg = builtins.attrValues cfg.defaults;
    
    inherit (lib) mkIf;
in
{
    imports = [
        ./shell
        ./theme
        ./module.nix

        ./hyprland.nix
        ./river.nix
        ./mango.nix
        ./sway.nix

        ./lockers/hyprlock.nix
        ./lockers/swaylock.nix

        inputs.mango.hmModules.mango-ext
    ];

    config = mkIf cfg.enable { 
        systemd.user.services.check_wm = mkIf cfg.systemd {
            Service = {
                ExecStart = "${pkgs.bash}/bin/bash check_wm";
                KillMode = "process";
            };
        };

        systemd.user.timers.check_wm = mkIf cfg.systemd {
            Timer = {
                OnBootSec = "60s";
                OnUnitActiveSec = "60s";
                Unit = "check_wm.service";
            };

            Install = {
                WantedBy = [ "timers.target" ];
            };
        };

        home.packages = forEachPkg ++ (with pkgs; [
            wl-clipboard
            swaysome # TODO move to sway module
            grim
            slurp
            wpaperd
            wofi
            kanshi

            # Gnome
            nautilus
            eog
            file-roller
            gnome-system-monitor
            gnome-calculator
            gnome-settings-daemon
        ]);

        wm = {
            modifier = "SUPER";
            keybinds = [
                { mod = true; key = "Return"; dispatch = "spawn"; arg = "${cfg.defaults.terminal}/bin/${cfg.defaults.terminal.meta.mainProgram}"; }
                { mod = true; sub_mod = "SHIFT"; key = "Q"; dispatch = "kill"; }
                { mod = true; key = "D"; dispatch = "spawn"; arg = "${pkgs.wofi}/bin/wofi"; }
                { mod = true; sub_mod = "SHIFT"; key = "C"; dispatch = "reload"; }
                { mod = true; key = "L"; dispatch = "spawn"; arg = "${cfg.defaults.locker}/bin/${cfg.defaults.locker.meta.mainProgram}"; }
                { mod = true; key = "N"; dispatch = "spawn"; arg = "togglenight"; }
                { mod = true; key = "C"; dispatch = "spawn_shell"; arg = "GRIM_DEFAULT_DIR=~/Pictures/Screenshots ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\""; }
                { mod = true; key = "B"; dispatch = "spawn_shell"; arg = "btwofi"; }
                { mod = true; key = "T"; dispatch = "spawn_shell"; arg = "translate"; } # Broken
                (mkIf cfg_ags.enable { mod = true; key = "Q"; dispatch = "spawn_shell"; arg = "ags request toggle_sidebar"; })
                (mkIf cfg_ags.enable { mod = true; key = "Z"; dispatch = "spawn_shell"; arg = "ags request toggle_menu"; })
                # (mkIf cfg.replays { mod = true; sub_mod = "SHIFT"; key = "R"; dispatch = "spawn_shell"; arg = "killall -SIGUSR1 gpu-screen-recorder && notify-send \"Replay Saved\""; })

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
                outer = 4;
                smartGaps = false;
                smartBorders = false;
            };

            startup = [
                "${pkgs.wpaperd}/bin/wpaperd"
                "${pkgs.kanshi}/bin/kanshi"
                "${pkgs.waybar}/bin/waybar"
            ];

            startup_always = [
                "ags quit & ags run"
                # ( mkIf (cfg.replays) "${pkgs.gpu-screen-recorder}/bin/gpu-screen-recorder -w ${config.settings.values.primary-monitor} -c mp4 -r 300 -restart-replay-on-save yes -o ~/Videos/Replays")
                "${pkgs.dbus}/bin/dbus-update-activation-environment --systemd PATH XDG_DATA_DIRS"
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
                border = 2;
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

        home.pointerCursor = {
            enable = true;
            name = "Adwaita";
            size = 16;
            package = pkgs.adwaita-icon-theme;

            gtk.enable = true;
            # sway.enable = mkIf (cfg.sway.enable) true; TODO readd after sway
        };

        xdg = {
            mime.enable = true;
            mimeApps = {
                enable = true;
                defaultApplicationPackages = with pkgs; [
                    mpv
                    eog
                    firefox
                ];
            };
        };
    };
}

