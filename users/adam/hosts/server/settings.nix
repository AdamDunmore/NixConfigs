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
                nixos = {
                    base.enable = true;
                    services.syncthing.enable = true;
                    services.tailscale.enable = true;
                };
                home = {
                    apps = {
                        media.beets = {
                            enable = true;
                            systemd = true;
                        };
                        user_apps = [];
                        scripts.enable = true;
                    };
                    terminal.shell.enable = true;
                };
            };
        };
    };
}
