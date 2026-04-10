{ lib, ... }:
{
    config.settings = {
        home.apps.level = lib.mkForce "all";
        home.wm.cosmic.enable = false; # TODO cant see mouse in sddm so this it my only way to get sway
        home.wm.primary-monitor = "eDP-1";
    };
}
