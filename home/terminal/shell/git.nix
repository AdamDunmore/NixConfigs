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
            settings = {
                user = {
                    name = "Adam Dunmore";
                    email = "adamfdunmore@gmail.com";
                };
            };
        };
    };  
}
