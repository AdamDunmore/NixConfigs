{ lib, config, font, colours, ... }:

let
    cfg = config.settings.home.widgets.wofi;
in
with lib;
{
    config = mkIf cfg {
        programs.wofi = {
            enable = true;
            settings = {
                allow_images = true;
                no_actions = true;
                show = "drun";
                height = 300;
                width = 600;
                prompt = "";
                matching = "multi-contains";
                insensitive = true;
            };
            style = ''
                window {
                    font-size: 22px;
                    font-family: "${font.name}";

                    border-radius: 10px;
                    border-width: 3px;
                    border-style: solid;
                    border-color: rgba(0,0,0,0.2);
                }

                #entry {
                    padding: 10px;
                    color: #ffffff;
                }

                #entry:selected {
                    border: none;
                }

                #text{
                    padding-left: 20px;
                }

                #input{
                    font-size: 24px;
                    padding: 10px;
                    margin: 10px;

                    border-radius: 5px;
                }
            '';
        };   
    };
}
