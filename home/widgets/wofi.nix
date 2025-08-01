{ lib, config, pkgs, font, colours, ... }:

let
    cfg = config.settings.home.widgets.wofi;
in
with lib;
{
    config = mkIf cfg {
        home.packages = [ pkgs.bzmenu ];

        programs.zsh.shellAliases = {
            btwofi = "bzmenu -s 2 --launcher custom --launcher-command \"wofi --show=dmenu\"";
        };

        programs.wofi = {
            enable = true;
            settings = {
                allow_images = false;
                no_actions = true;
                show = "drun";
                height = 30;
                width = "100%";
                prompt = "";
                insensitive = true;
                hide_scroll = true;
                matching = "multi-contains";
                location = 7;
                dynamic_lines = true;
                orientation = "horizontal";
            };
            style = ''
                * {
                    all: unset; 
                }

                window {
                    font-size: 10px;
                    font-family: "${font.name}";
                    background-color: ${colours.blue.one};
                }

                #inner-box {
                    padding: 0px;
                }

                #entry {
                    color: #ffffff;
                    padding: 3px;
                }

                #entry:selected {        
                    background-color: ${colours.blue.two};
                }

                #text{
                    padding: 2px;
                }

                #input{
                    padding: 3px;
                    margin-right: 4px;
                    margin-left: 4px;
                }
            '';
        };   
    };
}
