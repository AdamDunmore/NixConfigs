{ lib, config, ... }:
let
    inherit (lib) mkOption;
in
{
    imports = [
        ./editors
        ./emulators
        ./shell
    ];

    options.settings.modules.home.terminal = {
        enable = mkOption {
            type = lib.types.bool;
            default = config.settings.modules.home.enable;
            example = false;
            description = "Enables the terminal modules";
        };
    };
}
