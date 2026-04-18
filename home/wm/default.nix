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

    inherit (lib) mkIf;
in
{
    imports = [
        ./hyprland.nix
        ./river.nix
        ./mango.nix
        ./sway.nix

        ./lockers/hyprlock.nix
        ./lockers/swaylock.nix
    ];

    config = { 
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
