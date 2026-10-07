{ pkgs, lib, config, ... }:

let
    tr = pkgs.writeShellScriptBin "translate" ''
        TRANSLATED=$(${pkgs.translate-shell}/bin/trans -brief :en "$(read_screen -t)")
        action=$(notify-send "Translated" "$TRANSLATED" -A "copy=Copy Translation" --wait)
        if [ "$action" = "copy" ]; then
            wl-copy "$TRANSLATED"
        fi
    '';
    cfg = config.settings.modules.home.apps.scripts;
    inherit (lib) mkIf;
in
{
    config = mkIf cfg.enable {
        home.packages = [ 
            pkgs.tesseract
            pkgs.translate-shell

            tr 
        ];
        xdg.desktopEntries.translate = {
            name = "tr";
            genericName = "Translate";
            exec = "${tr}/bin/translate";
            terminal = false;
        }; 
    };
}
