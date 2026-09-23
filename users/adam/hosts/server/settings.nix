{ lib, ... }:
let
    inherit (lib) mkForce;
in
{
    imports = [
        ../../settings.nix
    ];
    config = {
        settings = {
            modules.enable = mkForce false;
        };
    };
}
