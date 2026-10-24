{ config, lib, user, pkgs, ... }:
let
    cfg = config.settings.modules.home.apps.media.beets;
    # custom-pkgs = import ../../../../pkgs/beets-xtractor.nix { inherit pkgs; };
    inherit (lib) mkIf; 
in
{
    config = mkIf cfg.enable {
        systemd.user.services.beets_check = mkIf cfg.systemd {
            Service = {
                ExecStart = ''
                    beet import -s /home/${user}/Music/Misc" && 
                    beet import -s /home/${user}/Music/Albums &&
                    beet update

                    beet autobpm

                    beet embedart

                    beet mbsync
                '';
                KillMode = "process";
            };
        };

        systemd.user.timers.beets_check = mkIf cfg.systemd {
            Timer = {
                OnBootSec = "6h";
                OnUnitActiveSec = "6h";
                Unit = "beets_check.service";
            };

            Install = {
                WantedBy = [ "timers.target" ];
            };
        };

        programs.beets = {
            enable = true;
            package = (pkgs.python314Packages.beets.override { pluginOverrides = { 
                # xtractor = {
                #   enable = true;
                #   propagatedBuildInputs = [
                #     (pkgs.callPackage ../../packages/beets-xtractor.nix {
                #       inherit (pkgs.python314Packages) buildPythonPackage;
                #       beets = pkgs.python314Packages.beets;
                #     })
                #   ];
                # };

                # beets-lyrics.enable = true; # TODO Fix timeout issue
                beets-autobpm.enable = true;
                beets-musicbrainz.enable = true;
                beets-embedart.enable = true;
                beets-ftintitle.enable = true;
                beets-mbsync.enable = true;
                beets-mpdupdate.enable = true;
                beets-lastgenre.enable = true;
            }; });

            settings = {
                plugins = [
                    "xtractor" # TODO package
                    # "lyrics"
                    "autobpm"
                    "musicbrainz"
                    "embedart"
                    "ftintitle"
                    "mbsync"
                    "mpdupdate"
                    "lastgenre"
                ];
                # xtractor = {
                #     essentia_extractor = "${pkgs.essentia-extractor}/bin/streaming_extractor_music";
                #     output_path = "/home/${user}/.local/share/beets-xtractor";
                #     threads = 1;
                #     auto = false;
                #     write = true;
                # };
                lastgenre = {
                    source = "track";
                    count = 5;
                    auto = true;
                };
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

