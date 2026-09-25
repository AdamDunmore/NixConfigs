{ lib, ... }:
let
    inherit (lib) mkForce;
in
{
    imports = [
        ../../settings.nix
    ];
    config = {
        settings.values.primary-monitor = "eDP-1";
        settings.modules.nixos.services.tailscale.enable = mkForce false;
        settings.modules.nixos.display_managers.default = "none";
        settings.modules.home.wm = {
            sway.enable = true;
        };
    };
}
