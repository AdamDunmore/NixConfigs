{ lib, config, ... }:
let
    cfg = config.settings.home.apps.music; 
    inherit (lib) mkIf;
in
{
    config = mkIf cfg {
        programs.rclone ={
            enable = true;
            remotes.nextcloud = {
                mounts = {
                    "Music_d" = {
                        enable = true;
                        mountPoint = "/home/adam/Music/Server";
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
        };
    };
}
