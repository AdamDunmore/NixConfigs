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
            values.primary-monitor = "eDP-1";
            modules = {

            };
        };
    };
}
