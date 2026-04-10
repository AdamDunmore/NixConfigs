{ lib, config, pkgs, ... }:
let
    cfg = config.settings.home.apps.misc.drive;
    inherit (lib) mkIf;
in
{
    config = mkIf cfg {
        # Creates drive directory
        home.activation.createDriveDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
            mkdir -p "$HOME/Drive"
        '';

        programs.rclone = {
            enable = true;
            remotes.drive = {
                config.type = "drive"; 
                secrets = {
                    # client_id = "/run/secrets/drive_client_id";
                    # client_secret = "/run/secrets/drive_secret";
                    token = "/run/secrets/drive_token";
                };
                mounts."store" = {
                    enable = true;
                    autoMount = true;
                    # remote = "drive:store";
                    mountPoint = "${config.home.homeDirectory}/Drive";
                };
            };
        };
    };
}
