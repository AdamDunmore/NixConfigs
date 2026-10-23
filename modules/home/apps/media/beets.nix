{ config, lib, user, pkgs, ... }:
let
    cfg = config.settings.modules.home.apps.media.beets;
    inherit (lib) mkIf; 
in
{
    config = mkIf cfg.enable {
        programs.beets = {
            enable = true;
            package = (pkgs.python314Packages.beets.override { pluginOverrides = { 
                # beets-xtractor.enable = true; # TODO Add as external plugin
                # beets-lyrics.enable = true; # TODO Fix timeout issue
                beets-autobpm.enable = true;
                beets-musicbrainz.enable = true;
                beets-embedart.enable = true;
                beets-ftintitle.enable = true;
                beets-mbsync.enable = true;
                beets-mpdupdate.enable = true;
            }; });

            settings = {
                plugins = [
                    # "xtractor" # TODO package
                    # "lyrics"
                    "autobpm"
                    "musicbrainz"
                    "embedart"
                    "ftintitle"
                    "mbsync"
                    "mpdupdate"
                ];
                # xtractor = {
                #     essentia_extractor = "${pkgs.essentia-extractor}/bin/streaming_extractor_music";
                # };
                directory = "/home/${user}/Music";
                ignore = [
                    "Downloads/"
                ];
                import = {
                    write = true;
                    copy = true;
                    # move = true;
                    from_scratch = true;
                    # quiet = true;
                    default_action = "apply";
                    bell = true;
                };
                match = {
                    strong_rec_thresh = 0.4;
                    distance_weights = {
                        missing_tracks = 0;
                    };
                };
                paths = {
                    default = "Albums/$albumartist - $album%aunique{}/$track - $title";
                    singleton = "Misc/$albumartist - $title";
                };
            };
        };
    };
}

