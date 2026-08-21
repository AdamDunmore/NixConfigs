{ lib, config, ... }:
let
    inherit (lib) mkOption;
in
{
    imports = [
        ./ghostty.nix
    ];

    options.settings.modules.home.terminal.emulators= {
        enable = mkOption {
            type = lib.types.bool;
            default = config.settings.modules.home.terminal.enable;
            example = false;
            description = "Enables the emulator modules";
        };
    };
}
