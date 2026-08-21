{ lib, ... }:
let
    inherit (lib) mkOption;
in
{
    options.settings.modules.nixos.base.virtualisation = {
        enable = mkOption {
            type = lib.types.bool;
            default = false;
            example = true;
            description = "Enables the virtualisation module";
        };
    };
}
