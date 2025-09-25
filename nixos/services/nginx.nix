{ config, lib, pkgs, ... }:
let
    cfg = config.settings.nixos.services.nginx;
    music-path = config.settings.home.apps.music.path;
    inherit (lib) mkIf;
in
{
    config = mkIf cfg {
        services.nginx = {
            enable = true;
            virtualHosts."dav.local" = {
                listen = [ { addr = "0.0.0.0"; port = 8080; } ];
                root = "/";
                locations = {
                    "/share/music".extraConfig = ''
                        root ${music-path};
                        dav_methods     PUT DELETE MKCOL COPY MOVE;
                        dav_ext_methods PROPFIND OPTIONS;
                        create_full_put_path on;
                        autoindex on;
                    '';
                };
            };
        };
    };
}
