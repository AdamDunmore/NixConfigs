{ lib, config, pkgs, ... }:

let
    cfg = config.settings.modules.home.terminal.shell.lsd;
    inherit (lib) mkIf;
in
{
    config = mkIf cfg.enable {
        home.shellAliases = { lst = "${pkgs.lsd}/bin/lsd --tree -l"; };
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
