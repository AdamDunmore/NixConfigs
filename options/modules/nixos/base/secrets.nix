{ lib, config, ... }:
let
    inherit (lib) mkOption mkEnableOption;
in
{
    options.settings.modules.nixos.base.secrets = {
        enable = mkOption {
            type = lib.types.bool;
            default = config.settings.modules.nixos.base.enable;
            example = false;
            description = "Enables the secrets module";
        };

        user_password = mkEnableOption "Sets user password to user_password in your sops file";
    };
}
