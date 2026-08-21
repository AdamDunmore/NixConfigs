{ lib, config, ... }:
let
    inherit (lib) mkOption;
in
{
    options.settings.modules.home.terminal.shell.tmux = {
        enable = mkOption {
            type = lib.types.bool;
            default = false;
            example = true;
            description = "Enables the tmux module";
        };
    };
}
