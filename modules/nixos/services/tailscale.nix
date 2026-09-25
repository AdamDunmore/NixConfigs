{ lib, config, ... }:
let
    cfg = config.settings.modules.nixos.services.tailscale;
    
    inherit (lib) mkIf;
in
{
    config = mkIf cfg.enable {
        services.tailscale = {
            enable = true;
            authKeyFile = mkIf (config.settings.modules.nixos.base.secrets.enable) config.sops.secrets.ts_key.path;
        };
    };
}
