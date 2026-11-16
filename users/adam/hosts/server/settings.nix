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
            modules = {
                nixos.base.enable = true;
                nixos.services.tailscale.enable = true;
                home.apps.user_apps = [];
                home.terminal.shell.enable = true;
            };
        };
    };
}
