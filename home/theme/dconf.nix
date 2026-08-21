{ pkgs, lib, config, ... }:
let
    cfg = config.settings.home.theme;
in

with lib.hm.gvariant;
{
    config = lib.mkIf cfg {
        dconf = {
            enable = true;
            settings = {
                "org/gnome/shell" = {
                    enabled-extensions = with pkgs.gnomeExtensions; [
                        bluetooth-quick-connect.extensionUuid
                        clipboard-indicator.extensionUuid
                        dash-to-panel.extensionUuid
                        user-themes.extensionUuid
                    ];
                    disabled-extensions = [];
                    disable-user-extensions = false;
                    "favorite-apps" = ["firefox.desktop" "org.gnome.Nautilus.desktop" "Alacritty.desktop"];
                };

                "org/gnome/shell/extensions/user-theme" = {
                    name = "Nordic";
                };

                "org/gnome/nautilus" = {
                    "default-folder-viewer" = "list-view";
                    "default-visible-columns" = ["name" "size" "type" "date_modified"];
                };

                "org/gnome/desktop/peripherals/touchpad" = {
                    tap-to-click = true;
                    two-finger-scrolling-enabled = true;
                };

                "org/gnome/desktop/input-sources" = {
                    sources = [ (mkTuple [ "xkb" "gb" ]) ];
                };

                "org/gnome/settings-daemon/plugins/media-keys" = {
                    custom-keybindings = [
                        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/adam-open-termincal/"
                    ];
                };

                "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/adam-open-terminal" = {
                    name = "Open Terminal";
                    command = "alacritty";
                    binding = "<Super>a";
                };
            };
        };  
    };
}
