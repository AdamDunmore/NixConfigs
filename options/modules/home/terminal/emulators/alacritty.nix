{ lib, config, pkgs, ... }:
let
    inherit (lib) mkOption;
in
{
    options.settings.modules.home.terminal.emulators.alacritty = {
        enable = mkOption {
            type = lib.types.bool;
            default = (config.settings.modules.home.wm.defaults.terminal == pkgs.alacritty);
            example = false;
            description = "Enables the alacritty module";
        };
    };
}
