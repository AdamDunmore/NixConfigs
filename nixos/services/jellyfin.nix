{ lib, config, ... }:
let
    cfg = config.settings.nixos.services.jellyfin;
    inherit (lib) mkIf;
in
{
    config = mkIf cfg {
        services.jellyfin.enable = true;
        networking.firewall.allowedTCPPorts = [ 8096 ];
    };
}
