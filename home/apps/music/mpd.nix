{ lib, config, ... }:
let
    cfg = config.settings.home.apps.music; 
    cfg_mopidy = config.settings.nixos.services.mopidy;
    inherit (lib) mkIf;
in
{
    config = mkIf cfg {
        services.mpd = mkIf (cfg_mopidy.enable == false) {
            enable = true;
            musicDirectory = "~/Music";
            extraConfig = ''
                audio_output {
                    type "pulse"
                    name "MPD PulseAudio Output"
                }
            '';
        };
    };
}
