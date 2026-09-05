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
            values.primary-monitor = "DP-2";
            modules = {
                home = {
                    wm.replays = true;
                };
                nixos = {
                    services.ai = {
                        enable = mkForce true;
                        enableRocm = true; 
                    };
                };
            };
        };
    };
}
