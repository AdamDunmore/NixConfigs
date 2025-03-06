{ lib, config, ... }:

let
    cfg = config.adam.terminal.shell.enable;
in
{
    config = lib.mkIf cfg {
        programs.zoxide = {
            enable = true; 
            enableZshIntegration = true;
        };
    }; 
}
