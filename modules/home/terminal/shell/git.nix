{ lib, config, user_info, ... }:

let
    cfg = config.settings.modules.home.terminal.shell.git;
    inherit (lib) mkIf;
in
{
    config = mkIf cfg.enable {
        programs.git = {
            enable = true;
            settings = {
                url."git@github.com:".insteadOf = mkIf cfg.ssh "https://github.com/";
                user = {
                    name = user_info.name;
                    email = user_info.email;
                };
            };
        };
    };  
}
