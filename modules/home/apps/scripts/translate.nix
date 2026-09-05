{ pkgs, lib, config, ... }:

let
    trans = pkgs.writeShellScriptBin "translate" ''
        IMGDIR="/tmp/translate-scr"

        TEXT=""
        TRANSLATED=""

        grim -g "$(${pkgs.slurp}/bin/slurp)" $IMGDIR
        TEXT=$(tesseract "$IMGDIR" - -l eng+rus+ara 2>/dev/null)
        TRANSLATED=$(trans -brief :en "$TEXT")
        notify-send "Translated" "$TRANSLATED"
    '';
    cfg = config.settings.modules.home.apps.scripts;
    inherit (lib) mkIf;
in
{
    config = mkIf cfg.enable {
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
