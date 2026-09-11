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
                    box { 
                        background: ${colours.blue.three} !important;
                        border-radius: 10px;
                    }

                    #TabsToolbar {  
                        background: ${colours.blue.two} !important;
                        padding: 0px !important;
                    }

                    .tabbrowser-tab .tab-background {
                        background: ${colours.light_blue.two} !important;
                    }

                    .tab-background[selected] {
                        background: ${colours.light_blue.one} !important;
                    }

                    #nav-bar {
                        background: ${colours.blue.one} !important;
                    }

                    #PersonalToolbar {
                        background: ${colours.blue.two} !important;
                    }
                '';
            };
        }; 
    };
}
