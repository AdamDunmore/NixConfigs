{ lib, config, ... }:

let
    cfg = config.settings.modules.home.terminal.shell.lsd;
    inherit (lib) mkIf;
in
{
    config = mkIf cfg.enable {
        programs.lsd = {
            enable = true;
            settings = {
                blocks = [
                    "name"
                    "date"
                    "permission"
                ];

                sorting.dir-grouping = "first";
                date = "+%X %d-%m-%y";
                layout = "grid";
                dereference = false;
                "no-symlink" = true;
                total-size = true;
                hyperlink = "auto";
                header = true;
                permission = "rwx";
            };
        };
    };  
}
