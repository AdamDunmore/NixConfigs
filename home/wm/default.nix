{ lib, config, pkgs, colours, ...}:

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
    ];

    config = { 
        wm = {
            modifier = "SUPER";
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
