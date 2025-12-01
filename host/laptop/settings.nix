{ lib, ... }:
{
    config.settings = {
        home.apps.level = lib.mkForce "light";
        home.wm.cosmic.enable = true;
        nixos.services.syncthing = true;
    };
}
