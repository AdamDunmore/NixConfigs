{ inputs, config, lib, ... }:
let
    cfg = config.settings.home.apps.level;
in
with lib;
{
    imports = [ inputs.nix-flatpak.homeManagerModules.nix-flatpak ];
    config = mkIf (cfg == "all" || cfg == "light") {
        services.flatpak = {
            enable = true;
            packages = [
                "io.github.zen_browser.zen"
            ];
        };
    };
}
