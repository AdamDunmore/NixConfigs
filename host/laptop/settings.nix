{ lib, ... }:
{
    config.settings = {
        home.apps.level = lib.mkForce "all";
        home.wm.primary-monitor = "eDP-1";
    };
}
