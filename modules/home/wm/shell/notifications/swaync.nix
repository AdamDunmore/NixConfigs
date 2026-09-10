{ config, lib, ... }:
let
    cfg = config.settings.modules.home.wm.shell.notifications.swaync;
    inherit (lib) mkIf;
in
{
    config = mkIf cfg.enable {
        services.swaync = {
            enable = true;
            settings = {
                positionX = "left";
                positionY = "top";
                layer = "overlay";
                notification-window-width = 400;
                ignore-gtk-theme = true;
                timeout = 8;
            };
            style = ''
                button {
                    background-color: alpha(@theme_bg_color, 0.7);
                    border: none;
                }

                button:hover{
                    background-color: alpha(@theme_bg_color, 0.9);
                }

                .notification {
                    background-color: alpha(@theme_base_color, 0.7);
                    font-size: 10px; 
                }

                .notification:hover, .notification-default-action:hover {
                    background-color: alpha(@theme_base_color, 0.8);
                    color: blue;
                }
            '';
        };
    };
}

