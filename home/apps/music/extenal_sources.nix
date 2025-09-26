{ lib, config, ... }:
let
    cfg_music = config.settings.home.apps.music;
    cfg = cfg_music.sources; 
    inherit (lib) mkIf;
in
{
    config = {
        programs.rclone ={
            enable = true;
            remotes.nextcloud = mkIf cfg.nextcloud {
                mounts = {
                    "Music_d" = {
                        enable = true;
                        mountPoint = "${cfg_music.path}/Server";
                        options = {
                            "vfs-cache-mode" = "minimal";
                            "vfs-read-chunk-size" = "128M";
                            "vfs-read-chunk-size-limit" = "1G";
                            "allow-other" = true;
                        };
                    };
                };
                secrets.pass = "/run/secrets/nextcloud_pass";
                config = {
                    type = "webdav";
                    url = "http://100.117.180.2/remote.php/dav/files/adam";
                    vendor = "nextcloud";
                    user = "adam";
                };
            };
            remotes.webdav = mkIf cfg.webdav {
                mounts."" = {
                    enable = true;
                    mountPoint = "${cfg_music.path}/Server";
                    options = {
                        "allow-other" = true;
                    };
                };
                config = {
                    type = "webdav";
                    url = "http://100.117.180.2:8080/music/";
                };
            };
        };
    };
}
