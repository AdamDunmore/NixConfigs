{ pkgs, lib, config, ... }:

let
  cfg = config.settings.home.terminal.shell.git;
  inherit (lib) mkIf;
in
{
    config = mkIf cfg {
        #Git credential helper setup
        programs.git = {
            enable = true;
            userName = "Adam Dunmore";
            userEmail = "adamfdunmore@gmail.com";
        };
    };  
}
