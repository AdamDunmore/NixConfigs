{ lib, ... }:
{
    config.settings = {
        home.apps.level = lib.mkForce "all";
        home.wm.cosmic.enable = true;
    };
}
