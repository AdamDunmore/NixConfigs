{ lib, config, ... }:
let
    inherit (lib) mkOption;
in
{
    imports = [
        ./apps
    	./terminal
        ./wm
    ];

    options.settings.modules.home = {
        enable = mkOption {
            type = lib.types.bool;
            default = config.settings.modules.enable;
            example = false;
            description = "Enables base home-manager modules";
        };
    };
}
