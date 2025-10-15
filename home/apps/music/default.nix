{ lib, config, pkgs, ... }:
{
    imports = [
        ./extenal_sources.nix
        ./rip.nix
        ./rmpc.nix
        ./spicetify.nix
        ./mpd.nix
    ];
}
