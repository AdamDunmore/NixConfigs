{ lib, pkgs, ... }:
{
    config.settings = {
        home.apps.level = lib.mkForce "all";
        home.apps.autostart = {
            enable = true;
            apps = with pkgs; [
                steam
                firefox
                discord

            ];
        };
        nixos.services.syncthing = true;
    };
}
