{ lib, config, ... }:
let
    cfg = config.settings.home.apps.music; 
    inherit (lib) mkIf;
in
{
    config = mkIf cfg.enable {
        programs.rclone ={
            enable = true;
            # remotes.nextcloud = {
            #     mounts = {
            #         "Music_d" = {
            #             enable = true;
            #             mountPoint = "${cfg.path}/Server";
            #             options = {
            #                 "vfs-cache-mode" = "minimal";
            #                 "vfs-read-chunk-size" = "128M";
            #                 "vfs-read-chunk-size-limit" = "1G";
            #                 "allow-other" = true;
            #             };
            #         };
            #     };
            #     secrets.pass = "/run/secrets/nextcloud_pass";
            #     config = {
            #         type = "webdav";
            #         url = "http://100.117.180.2/remote.php/dav/files/adam";
            #         vendor = "nextcloud";
            #         user = "adam";
            #     };
            # };
            remotes.webdav = {
                mounts = {
                    "Music" = {
                        enable = true;
                        mountPoint = "${cfg.path}/Server";
                        options = {
                            "vfs-cache-mode" = "full";
                            "vfs-read-chunk-size" = "128M";
                            "vfs-read-chunk-size-limit" = "1G";
                            "allow-other" = true;
                        };
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
