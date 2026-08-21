{ pkgs, config, lib, inputs, ... }:
let
    cfg = config.settings.modules.home.apps.media.spicetify;
    spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
    inherit (lib) mkIf;
in
{
    imports = [ inputs.spicetify-nix.homeManagerModules.default ];
    config = mkIf cfg.enable {
        home.packages = [ pkgs.spicetify-cli ];
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
