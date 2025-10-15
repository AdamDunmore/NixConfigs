{ config, lib, ... }:
let
    cfg = config.settings.home.apps.browser.firefox;
    inherit (lib) mkIf;
in
{
    config = mkIf cfg {
        programs.firefox = {
            enable = true;
        };
    };
}
