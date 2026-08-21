{ config, lib, ... }:
let
    cfg = config.settings.nixos.services.nh;
    inherit (lib) mkIf mkMerge;
in
{
    config = mkMerge [
        ( mkIf cfg {
            programs.nh = {
                enable = true;
                clean.enable = true;
                clean.extraArgs = "--keep-since 4d --keep 3";
                flake = "/home/adam/NixConfigs/";            
            };
        } )
        ( mkIf (cfg == false) {
            nix.gc = {
                automatic = true;
                options = "--delete-older-than 4d";
            };
        } )
    ];
}
