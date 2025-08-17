{ lib, config, pkgs, ... }:
let
    cfg = config.settings.home.apps.music;
    inherit (lib) mkIf; 
in
{
    config = mkIf cfg {
        services.mpd = {
            enable = true;
            extraConfig = ''
                audio_output {
                    type "pulse"
                    name "MPD PulseAudio Output"
                }
            '';
        };

        programs.beets = {
            enable = true;
            mpdIntegration.enableStats = true;
            settings = {
                directory = "~/Music";
                library = "~/Music/musiclibrary.db";
                plugins = [ "web" ];
            };
        };

        programs.rmpc.enable = true;

        xdg.desktopEntries.rmpc = {
            name = "rmpc";
            genericName = "music";
            exec = "${pkgs.alacritty}/bin/alacritty -e ${pkgs.rmpc}/bin/rmpc";
            terminal = false;
        }; 

        home.file.".config/rmpc/" = {
            recursive = true;
            source = ./.;
        };

        home.packages = with pkgs; [ 
            streamrip
            ffmpeg_6
        ];   

        home.shellAliases = {
            arip = "rip -q 2 -f $HOME/Music -c FLAC";
            d-music = "arip search tidal track";
            d-music-a = "arip search tidal";
            d-music-l = "arip lastfm";
        };
    };
}
