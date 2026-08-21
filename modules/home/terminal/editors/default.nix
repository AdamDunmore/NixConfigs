{ lib, config, ... }:
let
    inherit (lib) mkOption;
in
{
    imports = [
        ./nvim
    ];

    options.settings.modules.home.terminal.editors = {
        enable = mkOption {
            type = lib.types.bool;
            default = config.settings.modules.home.wm;
            example = false;
            description = "Enables the editor modules";
        };
    };
}
