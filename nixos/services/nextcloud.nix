{ pkgs, config, lib, ... }:
let
    cfg = config.settings.nixos.services.nextcloud;
    inherit (lib) mkIf;
in
{
    config = mkIf cfg {
        environment.etc."nextcloud-admin-pass".text = "123";
        services.nextcloud = {
            enable = true;
            package = pkgs.nextcloud31;
            hostName = "100.117.180.2";
            datadir = "/mnt/MediaDrive/NextCloud";
            config.adminpassFile = "/etc/nextcloud-admin-pass";
            config.dbtype = "sqlite";
        };
    };
}
