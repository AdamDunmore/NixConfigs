{ pkgs, lib, config, ... }:

let
    rs = pkgs.writeShellScriptBin "read_screen" ''
        IMGDIR="/tmp/screen-read-result"

        TEXT=""
        LANGS="eng"

        if [ "$1" = "-t" ]; then
            LANGS="eng+rus+ara"
        fi

        grim -g "$(${pkgs.slurp}/bin/slurp)" "$IMGDIR"
        TEXT=$(${pkgs.tesseract}/bin/tesseract "$IMGDIR" - -l $LANGS 2>/dev/null)
        echo "$TEXT"
        echo $1

        if [ "$1" = "-s" ]; then
            action=$(notify-send "Screen Read" "$TEXT" -A "copy=Copy Text" --wait)
            if [ "$action" = "copy" ]; then
                wl-copy "$TEXT"
            fi
        fi
    '';
    cfg = config.settings.modules.home.apps.scripts;
    inherit (lib) mkIf;
in
{
    config = mkIf cfg.enable {
        home.packages = [ 
            pkgs.tesseract

            rs 
        ];
        xdg.desktopEntries.read_screen = {
            name = "rs";
            genericName = "Read Screen";
            exec = "${rs}/bin/read_screen";
            terminal = false;
        }; 
    };
}
