{ lib, config, ... }:
let
    inherit (lib) mkOption;
in
{
    options.settings.modules.home.wm.theme.gtk = {
        enable = mkOption {
            type = lib.types.bool;
            default = config.settings.modules.home.wm.theme.enable;
            example = false;
            description = "Enables the gtk module";
        };
        overrideTheme = mkOption {
            type = lib.types.bool;
            default = config.settings.modules.home.wm.theme.gtk.enable;
            example = false;
            description = "Overrides the gtk theme with config.values.colours";
        };
    };
}
