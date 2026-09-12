{ pkgs, lib, config, ... }:
let
    font = config.settings.values.font;
    cfg = config.settings.modules.home.wm.theme.gtk; 
    colours = config.settings.values.colours;
    css = ''
        /* GTK3 compatibility */
        @define-color theme_bg_color ${colours.bg};
        @define-color theme_selected_bg_color ${colours.bg_selected};
        @define-color theme_fg_color ${colours.fg};
        @define-color theme_text_color ${colours.fg};
        @define-color theme_selected_fg_color ${colours.fg_selected};
        @define-color theme_base_color ${colours.base};
        @define-color borders ${colours.border};

        /* GTK4 / libadwaita */
        :root {
            --window-bg-color: ${colours.bg};
            --window-fg-color: ${colours.fg};

            --view-bg-color: ${colours.base};
            --view-fg-color: ${colours.fg};

            --sidebar-bg-color: ${colours.bg};
            --sidebar-fg-color: ${colours.fg};

            --headerbar-bg-color: ${colours.bg};
            --headerbar-fg-color: ${colours.fg};

            --popover-bg-color: ${colours.bg};
            --popover-fg-color: ${colours.fg};

            --card-bg-color: ${colours.bg_selected};
            --card-fg-color: ${colours.fg};

            --accent-bg-color: ${colours.bg_selected};
            --accent-fg-color: ${colours.fg_selected};
        }
    '';
    gtkTheme = import ./theme.nix {
        inherit pkgs;
        colours = config.settings.values.colours;
    };
    inherit (lib) mkIf;
in
{
    config = mkIf cfg.enable {
        gtk = {
            enable = true;
            gtk3.extraCss = mkIf cfg.overrideTheme css;
            gtk4.extraCss = mkIf cfg.overrideTheme css;
            theme = {
                name = "GTK-Generated";
                package = gtkTheme;
            };
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
