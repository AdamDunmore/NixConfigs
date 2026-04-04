{ config, lib, pkgs, ... }:

let
    cfg = config.settings.home.apps.level;
    trans = pkgs.writeShellScriptBin "translate" ''
        IMGDIR="/tmp/translate-scr"

        TEXT=""
        TRANSLATED=""

        grim -g "$(/nix/store/58nbl3yv5251wickxlqk2fc0jrb9bkpn-slurp-1.5.0/bin/slurp)" $IMGDIR
        TEXT=$(tesseract "$IMGDIR" - -l eng+rus+ara 2>/dev/null)
        TRANSLATED=$(trans -brief :en "$TEXT")
        notify-send "Translated" "$TRANSLATED"
    '';

    inherit (lib) mkIf;
in
{
    config = mkIf (cfg == "all" || cfg == "light") {
        home.packages = [ 
            pkgs.tesseract
            pkgs.translate-shell

            trans 
        ];
        xdg.desktopEntries.translate = {
            name = "trans";
            genericName = "Translate";
            exec = "${trans}/bin/translate";
            terminal = false;
        }; 
    };
}
