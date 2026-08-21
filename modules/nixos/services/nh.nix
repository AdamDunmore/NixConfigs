{ config, lib, ... }:
let
    cfg = config.settings.modules.nixos.services.nh;
    inherit (lib) mkIf;
in
{
    config = {
        programs.nh = mkIf (cfg.enable) {
            enable = true;
            clean.enable = true;
            clean.extraArgs = "--keep-since 4d --keep 3";
            flake = "/home/adam/NixConfigs/";            
        };

        nix.gc = mkIf (cfg.enable == false) {
            automatic = true;
            options = "--delete-older-than 4d";
        };
    };
}
