{ pkgs, config, lib, ... }:
let
    cfg = config.settings.home.apps.music; 
    inherit (lib) mkIf; 
in
{
    config = mkIf cfg.enable {
        home.packages = [ pkgs.streamrip ];   

        home.shellAliases = {
            arip = "rip -q 2 -f $HOME/Music -c FLAC";
            d-music = "arip search tidal track";
            d-music-a = "arip search tidal";
            d-music-l = "arip lastfm";
        };
    };
}
