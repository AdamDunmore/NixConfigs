{ inputs, config, lib, ... }:
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
            ];
        };
    };
}
