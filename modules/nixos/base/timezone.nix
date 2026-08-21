{ lib, config, ... }:
let
    cfg = config.settings.modules.nixos.base.timezone;
    inherit (lib) mkIf;
in
{
    config = mkIf cfg.enable {

        time.timeZone = "Europe/London"; # TODO add prefs?
        i18n.defaultLocale = "en_GB.UTF-8";
        i18n.extraLocaleSettings = {
            LC_ADDRESS = "en_GB.UTF-8";
            LC_IDENTIFICATION = "en_GB.UTF-8";
            LC_MEASUREMENT = "en_GB.UTF-8";
            LC_MONETARY = "en_GB.UTF-8";
            LC_NAME = "en_GB.UTF-8";
            LC_NUMERIC = "en_GB.UTF-8";
            LC_PAPER = "en_GB.UTF-8";
            LC_TELEPHONE = "en_GB.UTF-8";
            LC_TIME = "en_GB.UTF-8";
        };
    };
}
