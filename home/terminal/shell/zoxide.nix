{ lib, config, ... }:

let
    cfg = config.settings.home.terminal.shell.enable;
in
{
    config = lib.mkIf cfg {
        programs.zoxide = {
            enable = true; 
            enableZshIntegration = true;
        };
    }; 
}
