{ lib, ... }:
{
    config.settings = lib.mkForce{
        home.apps.level = "all";
    };
}
