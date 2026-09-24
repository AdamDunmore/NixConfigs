{ pkgs, lib, config, ... }:
let
    cfg = config.settings.modules.home.apps.misc.firefox;
    colours = config.settings.values.colours;
    inherit (lib) mkIf;
in
{
    config = mkIf cfg.enable {
        programs.firefox = {
            configPath = "${config.xdg.configHome}/mozilla/firefox";
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
                # about:config
                settings = {
                    # General
                    "browser.startup.homepage" = "https://start.me/";
                    "browser.tabs.inTitlebar" = 0;
                    "browser.compactmode.show" = true;
                    "browser.urlbar.suggest.searches" = false;
                    "browser.toolbars.bookmarks.visibility" = "always";
                    "browser.bookmarks.addedImportButton" = false;

                    # Styling
                    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

                    # Sidebar
                    "sidebar.verticalTabs" = true;
                    "sidebar.visibility" = "expand-on-hover";
                    "sidebar.main.tools" = "syncedtabs,history,bookmarks";
                    "sidebar.expandOnHover" = true;
                    "sidebar.animation.expand-on-hover.delay-duration-ms" = 0;		
                    "sidebar.animation.expand-on-hover.duration-ms" = 50;
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

                    #trust-icon-container, #tracking-protection-icon-container, #identity-box {
                        margin-right: 2px !important;
                    }

                    #PersonalToolbar {
                        background: ${colours.bg} !important;
                    }
                '';
            };
        }; 
    };
}
