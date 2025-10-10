{ lib, config, ... }:

let
    cfg = config.settings.home.terminal.shell.yazi;
in
with lib;
{
    config = mkIf cfg {
        programs.yazi = {
            enable = true;
            enableZshIntegration = config.settings.home.terminal.shell.zsh;
            settings = {
                manager = {
                    show_hidden = true;
                    show_symlink = true;
                };
                opener = {
                    edit = [
                        { run = "nvim $@"; block = true; for = "unix"; }
                    ];

                    view = [
                        { run = "gqview $@ -t  & disown %1 && exit"; block = true; for = "unix"; }
                    ];
                };
                open = {
                    prepend_rules = [
                        # Edits
                        { name = "*.html*"; use = "edit"; }
                        { name = "*.json*"; use = "edit"; }
                        { name = "*.js*"; use = "edit"; }
                        { name = "*.ts*"; use = "edit"; }
                        { name = "*.py*"; use = "edit"; }
                        { name = "*.java*"; use = "edit"; }
                        { name = "*.txt"; use = "edit"; }
                        { name = "*.c*"; use = "edit"; }
                        { name = "*.go"; use = "edit"; }
                        { name = "*.nix"; use = "edit"; }
                        { name = "*.md"; use = "edit"; }
                        { name = "*.vue"; use = "edit"; }
                        { name = "*.h"; use = "edit"; }
                        { name = "*.rs"; use = "edit"; }
                        { name = "*.toml"; use = "edit"; }
                        { name = "*.svg"; use = "edit"; }

                        # Images
                        { name = "*.png"; use = "view"; }
                        { name = "*.jpg"; use = "view"; }
                    ];
                };
            };
        };
    };
}
