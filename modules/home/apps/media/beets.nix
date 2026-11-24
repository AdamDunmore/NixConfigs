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
                ExecStart = pkgs.writeShellScript "beets-check" ''
                    set -e
                    ${pkgs.beets}/bin/beet update
                    ${pkgs.beets}/bin/beet autobpm -q
                    ${pkgs.beets}/bin/beet embedart -y
                    ${pkgs.beets}/bin/beet mbsync
                    ${pkgs.beets}/bin/beet lyrics
                    ${pkgs.beets}/bin/beet fetchart

                    ${pkgs.beets}/bin/beet write
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

                beets-lyrics.enable = true;
                beets-autobpm.enable = true;
                beets-musicbrainz.enable = true;
                beets-embedart.enable = true;
                beets-ftintitle.enable = true;
                beets-mbsync.enable = true;
                beets-mpdupdate.enable = true;
                beets-lastgenre.enable = true;
                beets-fetchart.enable = true;
            }; });

            settings = {
                plugins = [
                    # "xtractor" # TODO package
                    "lyrics"
                    "autobpm"
                    "musicbrainz"
                    "embedart"
                    "ftintitle"
                    "mbsync"
                    "mpdupdate"
                    "lastgenre"
                    "fetchart"
                ];
                # xtractor = {
                #     essentia_extractor = "${pkgs.essentia-extractor}/bin/streaming_extractor_music";
                #     output_path = "/home/${user}/.local/share/beets-xtractor";
                #     threads = 1;
                #     auto = false;
                #     write = true;
                # };
                embedart = {
                    remove_art_file = true;
                };
                lastgenre = {
                    source = "track";
                    count = 5;
                    auto = true;
                };
                lyrics = {
                    sources = [
                        "lrclib"
                        "lrcmux"
                    ];
                };
                directory = "/home/${user}/Music";
                ignore = [
                    "Downloads/"
                ];
                import = {
                    write = true;
                    copy = true;
                    move = true;
                    from_scratch = true;
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

