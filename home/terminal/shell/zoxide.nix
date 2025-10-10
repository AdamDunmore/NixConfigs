{ lib, config, ... }:

let
    cfg = config.settings.home.terminal.shell.zoxide;
in
{
    config = lib.mkIf cfg {
        programs.zoxide = {
            enable = true; 
            enableZshIntegration = config.settings.home.terminal.shell.zsh;
        };
    }; 
}
