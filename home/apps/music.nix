{ lib, config, pkgs, ... }:
let
    cfg = config.settings.home.apps.music;
    inherit (lib) mkIf; 
in
{
    config = mkIf cfg {
        services.mpd = {
            enable = true;
        };

        programs.rmpc = {
            enable = true;
            config = ''
                (
                    wrap_navigation: true,
                )
            '';
        };

        home.packages = [ pkgs.streamrip ];   
    };
}
