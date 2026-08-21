{ lib, config, ... }:

let
    cfg = config.settings.modules.home.terminal.shell.zoxide;
in
{
    config = lib.mkIf cfg.enable {
        programs.zoxide = {
            enable = true; 
            enableZshIntegration = config.settings.modules.home.terminal.shell.zsh.enable;
        };
    }; 
}
