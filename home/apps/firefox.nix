{ config, lib, ... }:
let
    cfg = config.settings.home.apps.level;
    inherit (lib) mkIf;
in
{
    config = mkIf (cfg == "light" || cfg == "all") {
        programs.firefox = {

        };
    };
}
