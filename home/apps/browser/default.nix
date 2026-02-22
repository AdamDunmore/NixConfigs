{ lib, config, ... }:
let
    cfg = config.settings.home.apps.browser;
    inherit (lib) mkIf;
in
{
    imports = [
        ./brave.nix
        ./firefox.nix
    ];

    config = {
        # Enables default browser
        settings.home.apps.browser.brave = mkIf (cfg.default == "brave") true; 
        settings.home.apps.browser.firefox = mkIf (cfg.default == "firefox") true; 
    };
}
