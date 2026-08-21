{ lib, config, ... }:
let
    inherit (lib) mkOption;
in
{
    options.settings.modules.home.terminal.shell.zellij = {
        enable = mkOption {
            type = lib.types.bool;
            default = false;
            example = true;
            description = "Enables the zellij module";
        };
    };
}
