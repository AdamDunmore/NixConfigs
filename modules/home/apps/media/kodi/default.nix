{ inputs, config, lib, pkgs, user, ... }:
let
    cfg = config.settings.modules.home.apps.media.kodi;
    package = pkgs.kodi-wayland;
    nimbus = import ./nimbus.nix { inherit pkgs; inherit package; };
    pov = import ./pov.nix { inherit pkgs; inherit package; inherit config; };
    inherit (lib) mkIf; 
in
{
    imports = [ inputs.sops-nix.homeManagerModules.sops ];
    config = mkIf cfg.enable {
        sops.secrets.tb_key = {
            sopsFile = ../../../../../users/${user}/secrets/secrets.yaml;
        };

        programs.kodi = {
            enable = true;
            package = package.withPackages (exts: [
                pov.pov

                nimbus.nimbusHelper
                nimbus.nimbusSkin
            ]);
            
            addonSettings = {
                "skin.nimbus" = {
                    touchmode = "true";
                    home_no_categories_widget = "true";
                    searchsetting = "1";
                    current_search_provider = "3";

                    homemenunomoviesbutton = "true";
                    homemenunotvshowsbutton = "true";
                    homemenunocustom1button = "true";
                    homemenunocustom2button = "true";
                    homemenunocustom3button = "true";
                    homemenunopicturesbutton = "true";
                    homemenunomusicbutton = "true";
                    homemenunomusicvideobutton = "true";
                    homemenunotvbutton = "true";
                    homemenunoradiobutton = "true";
                    homemenunogamesbutton = "true";
                    homemenunoprogramsbutton = "true";
                    homemenunovideosbutton = "true";
                    homemenunofavbutton = "true";
                    homemenunoweatherbutton = "true";

                    "skin.forcedview." = "FlixList";
                    "skin.forcedview.addons" = "FlixList";
                };
            };
        };

        home.file = {
            ".kodi/addons/plugin.video.pov".source = "${pov.pov}/share/kodi/addons/plugin.video.pov";
            ".kodi/addons/skin.nimbus".source = "${nimbus.nimbusSkin}/share/kodi/addons/skin.nimbus";
            ".kodi/addons/script.nimbus.helper".source = "${nimbus.nimbusHelper}/share/kodi/addons/script.nimbus.helper";
            ".kodi/userdata/guisettings.xml".text = nimbus.guiSettings; 
        };

        sops.templates."pov-settings.xml" = {
            path = "${config.home.homeDirectory}/.kodi/userdata/addon_data/plugin.video.pov/settings.xml";
            content = pov.povSettings;
        };

    };
}
