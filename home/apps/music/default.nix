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

        programs.rmpc.enable = true;

        home.file.".config/rmpc/" = {
            recursive = true;
            source = ./.;
        };

        home.packages = [ pkgs.streamrip ];   

        programs.zsh.shellAliases = {
            arip = "rip -f $HOME/Music - q 4 -c FLAC"
            d-music = "arip search tidal track";
            d-music-a = "arip search tidal";
            d-music-l = "arip lastfm";
        };
    };
}
