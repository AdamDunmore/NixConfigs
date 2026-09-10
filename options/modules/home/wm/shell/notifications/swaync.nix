{ lib, config, ... }:
let
    inherit (lib) mkOption;
in
{
    options.settings.modules.home.wm.shell.notifications.swaync = {
        enable = mkOption {
            type = lib.types.bool;
            default = config.settings.modules.home.wm.shell.notifications.enable;
            example = false;
            description = "Enables the swaync module";
        };
    };
}
