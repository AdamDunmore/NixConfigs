{ lib, config, ... }:
let
    inherit (lib) mkOption;
in
{
    options.settings.modules.home.wm.shell.wofi = {
        enable = mkOption {
            type = lib.types.bool;
            default = false;
            example = true;
            description = "Enables the wofi modules";
        };
    };
}
