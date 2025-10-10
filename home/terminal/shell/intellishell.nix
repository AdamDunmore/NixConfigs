{ lib, config, ... }:
let
    cfg = config.settings.home.terminal.shell.intellishell;
    inherit (lib) mkIf;
in
{
    config = mkIf cfg {
        programs.intelli-shell = {
            enable = true;
            enableZshIntegration = config.settings.home.terminal.shell.zsh;
        };
    };
}
