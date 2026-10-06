{ lib, config, ... }:

let
    cfg = config.settings.modules.home.terminal.shell.git;
    inherit (lib) mkIf;
in
{
    config = mkIf cfg.enable {
        programs.git = {
            enable = true;
            settings = {
                url."git@github.com:".insteadOf = "https://github.com/"; # TODO and this
                user = { # TODO change this
                    name = "Adam Dunmore";
                    email = "adamfdunmore@gmail.com";
                };
            };
        };
    };  
}
