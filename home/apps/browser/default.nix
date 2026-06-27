{ lib, config, ... }:
let
    cfg = config.settings.home.apps.browser;
    inherit (lib) mkIf;
in
{
    imports = [
        ./firefox.nix
    ];

    config = {
        # Enables default browser
        settings.home.apps.browser.firefox = mkIf (cfg.default == "firefox") true; 
    };
}
