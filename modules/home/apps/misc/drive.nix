{ lib, config, ... }:
let
    cfg = config.settings.modules.home.apps.misc.drive;
    inherit (lib) mkIf;
in
{
    config = mkIf cfg.enable {
        # Creates drive directory
        home.activation.createDriveDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
            mkdir -p "$HOME/Drive"
        '';

        programs.rclone = {
            enable = true;
            remotes.drive = {
                config.type = "drive"; 
                secrets = {
                    token = "/run/secrets/drive_token";
                };
                mounts."store" = {
                    enable = true;
                    autoMount = true;
                    mountPoint = "${config.home.homeDirectory}/Drive";
                };
            };
        };
    };
}
