{ lib, ... }:
{
    config.settings = {
        home.apps.level = lib.mkForce "light";
    };
}
