{ config, lib, ... }:
let
    cfg = config.settings.modules.home.apps.media.mpd;
    inherit (lib) mkIf; 
in
{
    config = mkIf cfg.enable {
        services.mpd = {
            enable = true;
            musicDirectory = "~/Music";

            # TODO integrate upmpdcli upmdcli-qobuz and upmdcli-uprcl
            # https://www.lesbonscomptes.com/upmpdcli/pages/downloads.html
                # database {
                #     plugin "upnp"
                # }
            extraConfig = ''
                audio_output {
                    type "pulse"
                    name "MPD PulseAudio Output"
                }
            '';
        };
    };
}

