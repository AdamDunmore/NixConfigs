{ pkgs, lib, config, ... }:
let
    font = config.settings.values.font;
    cfg = config.settings.modules.home.wm.theme.gtk; 
    colours = config.settings.values.colours;
    # TODO improve css
    css = '' 
        @define-color theme_bg_color ${colours.bg};
        @define-color theme_selected_bg_color ${colours.bg_selected};
        @define-color theme_fg_color ${colours.fg};
        @define-color theme_text_color ${colours.fg};
        @define-color theme_selected_fg_color ${colours.fg_selected};

        @define-color theme_base_color ${colours.base};
        @define-color borders ${colours.border};

        * {
            color: @theme_fg_color;
            border-radius: 10px;
        }

        window,
        windowhandle,
        deck,
        headerbar,
        .background,
        .horizontal,
        .vertical {
            background-image: none;
            background-color: @theme_bg_color;
            color: @theme_fg_color;
        }

        entry,
        textview,
        spinbutton,
        .view {
            background-color: @theme_base_color;
            color: @theme_text_color;
        }

        button, button label, .activatable box, viewport, box.card, widget.sidebar-pane, revealer, .image-button {
            color: @theme_fg_color;
            background-color: @theme_bg_color;
            transition: background-color 0.5s;
            background-image: none;
            border: none;
        }

        button:hover, button:hover label, .activatable:hover box, .image-button:hover {
            background-color: @theme_selected_bg_color;
            color: @theme_selected_fg_color;
        }

        selection {
            background-color: @theme_selected_bg_color;
            color: @theme_selected_fg_color;
        }
    '';
    inherit (lib) mkIf;
in
{
    config = mkIf cfg.enable {
        gtk = {
            enable = true;
            gtk3.extraCss = mkIf cfg.overrideTheme css;
            gtk4.extraCss = mkIf cfg.overrideTheme css;
            gtk4.theme = config.gtk.theme;
            iconTheme = {
                name = "Papirus-Dark";
                package = pkgs.papirus-icon-theme;
            };
            font = {
                name = font.name;
                package = font.pkg;
            };
        };
    };
}
