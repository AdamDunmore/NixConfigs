{ lib, config, pkgs, ... }:
let
    inherit (lib) mkOption;
in
{
    options.settings.modules.home.apps.misc.flatpak = {
        enable = mkOption {
            type = lib.types.bool;
            default = config.settings.modules.home.apps.misc.enable;
            example = false;
            description = "Enables the flatpak module";
        };
        packages = mkOption {
            type = lib.types.listOf (lib.types.either lib.types.str (lib.types.attrsOf lib.types.anything));
            default = [];
            example = [ 
                "io.github.zen_browser.zen" 
                rec { # Amethyst 
                    appId = "io.github.ChrisDKN.AmethystModManager";
                    sha256 = "1yy07nqjg4mg73f2py1vm6if675k6adw5nbq5pcbydlis9dpyfzm"; 
                    bundle = "${pkgs.fetchurl {
                      url = "https://github.com/ChrisDKN/Amethyst-Mod-Manager/releases/download/v1.3.8/AmethystModManager.flatpak";
                      inherit sha256;
                    }}";
                }

            ];
            description = "A list of package addresses or definitions";
        };
    };
}
