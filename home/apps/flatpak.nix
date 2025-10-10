{ inputs, config, lib, ... }:
let
    cfg = config.settings.home.apps.level;
    inherit (lib) mkIf;
in
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
