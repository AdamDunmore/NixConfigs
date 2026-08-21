{ lib, config, ... }:
let
    cfg = config.settings.modules.home.terminal.shell.intellishell;
    inherit (lib) mkIf;
in
{
    config = mkIf cfg.enable {
        programs.intelli-shell = {
            enable = true;
            enableZshIntegration = config.settings.modules.home.terminal.shell.zsh.enable;
        };
    };
}
