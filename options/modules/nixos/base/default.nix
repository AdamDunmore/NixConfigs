{ lib, config, ... }:
let
    inherit (lib) mkOption;
in
{
    imports = [
        ./audio.nix
        ./bluetooth.nix
        ./bootloader.nix
        ./secrets.nix
        ./timezone.nix
        ./users.nix
        ./virtualisation.nix
    ];
    options.settings.modules.nixos.base = {
        enable = mkOption {
            type = lib.types.bool;
            default = config.settings.modules.nixos.enable;
            example = false;
            description = "Enables base nixos modules";
        };
    };
}
