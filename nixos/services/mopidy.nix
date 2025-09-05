{ config, lib, pkgs, ... }:
let
    cfg = config.settings.nixos.services.mopidy;
    inherit (lib) mkIf;
in
{
    config = mkIf cfg.enable {
        services.mopidy = {
            enable = true;
            extensionPackages = with pkgs;[
                mopidy-mpd
                mopidy-iris
                mopidy-tidal
                mopidy-local
                mopidy-subidy
                # mopidy-notify
            ];
            extraConfigFiles = [ config.sops.templates."mopidy.conf".path ];

            configuration = lib.generators.toINI {} {
                audio = {
                    output = "autoaudiosink";
                };
                core = {
                    restore_state = true;
                };
                local = {
                    enabled = true;
                };
                subidy = {
                    enabled = true;
                    url = "http://100.117.180.2/apps/music/subsonic";
                    username = "adam";
                    legacy_auth = true;
                };
                tidal = {
                    enabled = true;
                    quality = "LOSSLESS";
                    lazy = true;
                };
                http = {
                    hostname = "0.0.0.0";
                    port = 6680;
                };
                local = {
                   media_dir = cfg.path; 
                };
            };
        };  
    };
}
