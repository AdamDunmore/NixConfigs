{ lib, config, ... }:
let
    inherit (lib) mkOption;
in
{
    options.settings.modules.nixos.base.audio = {
        enable = mkOption {
            type = lib.types.bool;
            default = config.settings.modules.nixos.base.enable;
            example = false;
            description = "Enables the audio module";
        };
    };
}
