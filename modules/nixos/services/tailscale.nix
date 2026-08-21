{ lib, config, ... }:
let
    cfg = config.settings.modules.nixos.services.syncthing;
    
    inherit (lib) mkIf;
in
{
    config = mkIf cfg.enable {
        services.tailscale = {
            enable = true;
            authKeyFile = config.sops.secrets.ts_key.path;
        };
    };
}
