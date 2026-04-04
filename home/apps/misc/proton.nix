{ lib, config, pkgs, ... }:
let
    cfg = config.settings.home.apps.misc.proton;
    inherit (lib) mkIf;
in
{
    config = mkIf true {
        home.packages = with pkgs; [ 
            proton-pass
            protonmail-desktop
            protonvpn-gui
        ];

        # Creates drive directory
        home.activation.createDriveDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
            mkdir -p "$HOME/Drive"
        '';

        programs.rclone = {
            enable = true;
            remotes.proton = {
                config = {
                    type = "protondrive";
                    username = "adamfinlaydunmore@proton.me";
                }; 
                secrets.password = "/run/secrets/proton_pass";
                mounts."" = {
                    enable = true;
                    autoMount = true;
                    mountPoint = "${config.home.homeDirectory}/Drive";

                    options = {
                        vfs-cache-mode = "writes";
                        # vfs-write-back = "5s";
                        # dir-cache-time = "10s";
                        # poll-interval = "10s";
                    };
                };
            };
        };
    };
}
