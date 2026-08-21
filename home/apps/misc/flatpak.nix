{ inputs, config, lib, pkgs, ... }:
let
    cfg = config.settings.home.apps.misc.flatpak;
    cfg_level = config.settings.home.apps.level;
    inherit (lib) mkIf;
in
{
    imports = [ inputs.nix-flatpak.homeManagerModules.nix-flatpak ];
    config = mkIf cfg {
        services.flatpak = {
            enable = true;
            packages = mkIf (cfg_level == "all" || cfg_level == "light") [
                "io.github.zen_browser.zen"
                "org.vinegarhq.Sober"
                "io.mrarm.mcpelauncher"
                "com.github._0negal.Viper"

                # rec { # Amethyst 
                #     appId = "io.github.ChrisDKN.AmethystModManager";
                #     sha256 = "1yy07nqjg4mg73f2py1vm6if675k6adw5nbq5pcbydlis9dpyfzm"; 
                #     bundle = "${pkgs.fetchurl {
                #       url = "https://github.com/ChrisDKN/Amethyst-Mod-Manager/releases/download/v1.3.8/AmethystModManager.flatpak";
                #       inherit sha256;
                #     }}";
                # }
            ];
        };
    };
}
