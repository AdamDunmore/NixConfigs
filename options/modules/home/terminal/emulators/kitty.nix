{ lib, config, pkgs, ... }:
let
    inherit (lib) mkOption;
in
{
    options.settings.modules.home.terminal.emulators.kitty = {
        enable = mkOption {
            type = lib.types.bool;
            default = (config.settings.modules.home.wm.defaults.terminal == pkgs.kitty);
            example = false;
            description = "Enables the kitty module";
        };
    };
}
