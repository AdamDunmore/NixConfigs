{ pkgs, lib, config, ... }:
let
    cfg = config.settings.modules.home.apps.misc.firefox;
    colours = config.settings.values.colours;
    inherit (lib) mkIf;
in
{
    config = mkIf cfg.enable {
        programs.firefox = {
            enable = true;
            policies = {
                Sync = {
                    Enabled = true;
                    History = true;
                    OpenTabs = true;
                    Addons = true;
                    Bookmarks = true;

                    Passwords = false;
                    Settings = false;

                    Locked = true;
                };
            };
            profiles.default = {
                settings = {
                    "browser.startup.homepage" = "https://start.me/";
                    "browser.tabs.inTitlebar" = 0;
                    "browser.compactmode.show" = true;
                    "browser.urlbar.suggest.searches" = false;
                    "browser.toolbars.bookmarks.visibility" = "always";
                    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
                };

                userChrome = ''
                    * {
                        color: ${colours.fg} !important;
                    }

                    box { 
                        background: ${colours.base} !important;
                        border-radius: 10px;
                    }

                    #TabsToolbar {  
                        background: ${colours.bg} !important;
                        padding: 0px !important;
                    }

                    .tabbrowser-tab .tab-background {
                        background: ${colours.bg} !important;
                    }

                    .tab-background[selected] {
                        background: ${colours.bg_selected} !important;
                    }

                    #nav-bar {
                        background: ${colours.bg_selected} !important;
                    }

                    #PersonalToolbar {
                        background: ${colours.bg} !important;
                    }
                '';
            };
        }; 
    };
}
