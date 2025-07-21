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
            d-music = "rip -f $HOME/Music -q 3 search tidal track";
            d-music-a = "rip -f $HOME/Music -q 3 search tidal";
            d-music-l = "rip -f $HOME/Music -q 3 lastfm";
        };
    };
}
