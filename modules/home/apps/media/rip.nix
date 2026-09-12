{ pkgs, config, lib, ... }:
let
    cfg = config.settings.modules.home.apps.media.rip;
    streamrip = pkgs.streamrip.overrideAttrs(old: {
        src = pkgs.fetchFromGitHub {
            owner = "mikelandzelo173";
            repo = "streamrip";
            rev = "81a803e64ef9ff34751d6eedf82471c22e1cf4c6";
            hash = "sha256-wdMnwNKA0NHSMQFtRzDvqty/KCuxov0/i19jJw/5rlg=";
        };

        propagatedBuildInputs =
            old.propagatedBuildInputs
        ++ [ pkgs.python3Packages.playwright ];
    });
    inherit (lib) mkIf; 
in
{
    config = mkIf cfg.enable {
        home.packages = [ streamrip ];   

        home.shellAliases = {
            arip = "${streamrip}/bin/rip -q 3 -f $HOME/Music/Downloads/ -c FLAC";
            d-music = "arip search qobuz track";
            d-music-a = "arip search qobuz";
            d-music-l = "arip lastfm";
        };
    };
}
