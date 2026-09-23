{ lib, config, ... }:

let
    cfg = config.settings.modules.home.terminal.shell.yazi;
    inherit (lib) mkIf;
in
{
    config = mkIf cfg.enable {
        programs.yazi = {
            enable = true;
            enableZshIntegration = config.settings.modules.home.terminal.shell.zsh.enable;
            shellWrapperName = "yy";
            settings = {
                yazi = {
                    mgr = {
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

                        play = [
                            { run = "mpv"; for = "unix"; }
                        ];
                    };
                    open = {
                        prepend_rules = [
                            # Edits
                            { url = "*.html*"; use = "edit"; }
                            { url = "*.json*"; use = "edit"; }
                            { url = "*.js*"; use = "edit"; }
                            { url = "*.ts*"; use = "edit"; }
                            { url = "*.py*"; use = "edit"; }
                            { url = "*.java*"; use = "edit"; }
                            { url = "*.txt"; use = "edit"; }
                            { url = "*.c*"; use = "edit"; }
                            { url = "*.go"; use = "edit"; }
                            { url = "*.nix"; use = "edit"; }
                            { url = "*.md"; use = "edit"; }
                            { url = "*.vue"; use = "edit"; }
                            { url = "*.h"; use = "edit"; }
                            { url = "*.rs"; use = "edit"; }
                            { url = "*.toml"; use = "edit"; }
                            { url = "*.svg"; use = "edit"; }

                            # Images
                            { url = "*.png"; use = "view"; }
                            { url = "*.jpg"; use = "view"; }
                            
                            # Videos
                            { url = "*.mp4"; use = "play"; }
                            { url = "*.flac"; use = "play"; }
                        ];
                    };
                };
            };
        };
    };
}
