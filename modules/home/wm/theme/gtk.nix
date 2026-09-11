{ pkgs, lib, config, ... }:
let
    font = config.settings.values.font;
    cfg = config.settings.modules.home.wm.theme.gtk; 
    colours = config.settings.values.colours;
    css = ''
      @define-color theme_bg_color ${colours.bg};
      @define-color theme_selected_bg_color ${colours.bg_selected};
      @define-color theme_fg_color ${colours.fg};
      @define-color theme_text_color ${colours.fg};
      @define-color theme_selected_fg_color ${colours.fg_selected};

      @define-color theme_base_color ${colours.base};
      @define-color borders ${colours.border};

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
            theme = {
                name = "Nordic";
                package = pkgs.nordic;
            };
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
