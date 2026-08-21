{ lib, config, ... }:
let
    inherit (lib) mkOption;
in
{
    options.settings.modules.home.wm.shell.waybar = {
        enable = mkOption {
            type = lib.types.bool;
            default = config.settings.modules.home.wm.shell.enable;
            example = false;
            description = "Enables the waybar module";
        };
    };
}
