{ pkgs, config, lib, inputs, ... }:

let
    cfg = config.adam.apps;
    spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in
with lib;
{
    imports = [ inputs.spicetify-nix.homeManagerModules.default ];
    config = mkIf (cfg.light || cfg.all) {

        programs.spicetify = {
            enable = true;
            theme = spicePkgs.themes.burntSienna;

            enabledExtensions = with spicePkgs.extensions; [
                hidePodcasts
                lastfm
                fullAppDisplay
                popupLyrics
                skipOrPlayLikedSongs
                powerBar

                skipOrPlayLikedSongs
                showQueueDuration
                history
                playNext
                volumePercentage
                skipAfterTimestamp
                groupSession
            ];
        };
    };
}
