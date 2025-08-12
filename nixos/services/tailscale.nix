{ lib, config, pkgs, ... }:
let
    cfg = config.settings.nixos.services.tailscale;
    
    inherit (lib) mkIf;
in
{
    config = mkIf cfg {
        services.tailscale = {
            enable = true;
            authKeyFile = config.sops.secrets.ts_key.path;
        };
    };
}
