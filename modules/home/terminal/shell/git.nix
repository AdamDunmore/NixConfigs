{ lib, config, ... }:

let
    cfg = config.settings.modules.home.terminal.shell.git;
    inherit (lib) mkIf;
in
{
    config = mkIf cfg.enable {
        # TODO move to script which takes i (how far back in the log)
        home.shellAliases = { gl1 = "wl-copy $(git log -n 1 | grep \"commit\" | cut -d \" \" -f 2)"; };
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
