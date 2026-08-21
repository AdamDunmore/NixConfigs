{ lib, config, ... }:
let
    inherit (lib) mkOption;
in
{
    imports = [
        ./ai.nix
        ./nh.nix
        ./syncthing.nix
        ./tailscale.nix
    ];
    options.settings.modules.nixos.services = {
        enable = mkOption {
            type = lib.types.bool;
            default = config.settings.modules.nixos.enable;
            example = false;
            description = "Enables nixos services modules";
        };
    };
}
