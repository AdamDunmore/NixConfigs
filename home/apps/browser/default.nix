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

        # TODO 
        # Fixed fault browser
        # Not all tags are here
        # Not applied everytime
        # xdg = mkIf cfg.firefox {
        xdg = mkIf false {
            mime.enable = true;
            mimeApps = {
                enable = true;
                defaultApplications = {
                    "x-scheme-handler/about" = "firefox.desktop";
                    "x-scheme-handler/unknown" = "firefox.desktop";
                };
            };
        };
    };
}
