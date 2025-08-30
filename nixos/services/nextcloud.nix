{ pkgs, ... }:

{
    environment.etc."nextcloud-admin-pass".text = "123";
    services.nextcloud = {
        enable = true;
        package = pkgs.nextcloud31;
        hostName = "100.117.180.2";
        datadir = "/mnt/MediaDrive/NextCloud";
        config.adminpassFile = "/etc/nextcloud-admin-pass";
        config.dbtype = "sqlite";
    };
}
