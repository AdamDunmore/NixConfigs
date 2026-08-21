{ lib, config, pkgs, ... }:
let
    inherit (lib) mkOption;
in
{
    options.settings.modules.home.terminal.emulators.ghostty = {
        enable = mkOption {
            type = lib.types.bool;
            default = (config.settings.modules.home.wm.defaults.terminal == pkgs.ghostty);
            example = false;
            description = "Enables the ghostty module";
        };
    };
}
