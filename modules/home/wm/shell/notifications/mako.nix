{ config, lib, ... }:
let
    cfg = config.settings.modules.home.wm.shell.notifications.mako;
    colours = config.settings.values.colours;
    font = config.settings.values.font;
    inherit (lib) mkIf;
in
{
    config = mkIf cfg.enable {
        services.mako = {
            enable = true;
            settings = {
                actions = true;
                anchor = "top-left";
                background-color = "${colours.bg}AA";
                border-color = "${colours.border}FF";
                border-radius = 10;
                border-size = 1;
                default-timeout = 8000;
                font = "${font.name} 10";
                layer = "overlay";
                max-visible = 3;
                sort = "-time";
                height = 300;
                icons = true;
                icon-border-radius=10;
                icon-path = "${config.gtk.iconTheme.package}/share/icons/${config.gtk.iconTheme.name}";
            };
        };
    };
}

