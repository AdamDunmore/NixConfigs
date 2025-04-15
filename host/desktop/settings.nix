{ lib, pkgs, ... }:
{
    config.settings = {
        home.apps.level = lib.mkForce "all";
        home.autostart = {
            enable = true;
            apps = with pkgs; [
                steam
                tidal-hifi
                discord
            ];
        };
    };
}
