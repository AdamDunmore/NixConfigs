{ lib, config, ... }:
let
    inherit (lib) mkOption;
in
{
    options.settings.modules.home.terminal.shell.intellishell = {
        enable = mkOption {
            type = lib.types.bool;
            default = config.settings.modules.home.terminal.shell.enable;
            example = false;
            description = "Enables the zoxide module";
        };
    };
}
