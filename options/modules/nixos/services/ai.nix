{ lib, config, ... }:
let
    inherit (lib) mkOption;
in
{
    options.settings.modules.nixos.services.ai = {
        enable = mkOption {
            type = lib.types.bool;
            default = config.settings.modules.nixos.base.enable;
            example = false;
            description = "Enables the audio module";
        };
        enableRocm = mkOption {
            type = lib.types.bool;
            default = false;
            example = true;
            description = "Enables AMD rocm";
        };

    };
}
