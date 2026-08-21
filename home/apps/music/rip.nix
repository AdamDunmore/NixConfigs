{ pkgs, config, lib, ... }:
let
    cfg = config.settings.home.apps.music; 
    inherit (lib) mkIf; 
in
{
    config = mkIf cfg.enable {
        home.packages = [ pkgs.streamrip ];   

        home.shellAliases = {
            arip = "rip -q 3 -f $HOME/Music/Downloads/ -c FLAC";
            d-music = "arip search qobuz track";
            d-music-a = "arip search qobuz";
            d-music-l = "arip lastfm";
        };
    };
}
