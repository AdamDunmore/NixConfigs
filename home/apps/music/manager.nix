{ pkgs, config, user, lib, ... }:
let
    music-path = config.settings.home.apps.music.path;
    cfg = config.settings.home.apps.music; 
    inherit (lib) mkIf;
in
{
    config = mkIf cfg.enable {
        # webdav

        # Add commands to add music
        home.packages = [ pkgs.streamrip ];   
        home.shellAliases = {
            arip = "rip -q 2 -f $HOME/Music -c FLAC";
            d-music = "arip search tidal track";
            d-music-a = "arip search tidal";
            d-music-l = "arip lastfm";
        };


        #Define Groups
        users.groups.media = {};

        # Define folders
        systemd.tmpfiles.settings.music = let 
            file-settings = {
                group = "media";
                mode = "0774";
                inherit user;
            };
        in{
            "${music-path}/Local".c = file-settings; # Some kind of file sync?
            "${music-path}".c = file-settings;
        };
         

        # Remove web api

        # rip search web ui?
    };
}
