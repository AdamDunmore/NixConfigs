{ lib, config, ... }:
let
    inherit (lib) mkOption mkEnableOption;
in
{
    options.settings.modules.home.terminal.shell.git = {
        enable = mkOption {
            type = lib.types.bool;
            default = config.settings.modules.home.terminal.shell.enable;
            example = false;
            description = "Enables the git module";
        };
        ssh = mkEnableOption "Enable git ssh";
    };
}
