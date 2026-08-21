{ lib, config, ... }:
let
    inherit (lib) mkOption;
in
{
    options.settings.modules.home.terminal.editors.nvim = {
        enable = mkOption {
            type = lib.types.bool;
            default = config.settings.modules.home.terminal.enable;
            example = false;
            description = "Enables the nvim module";
        };
    };
}
