{ lib, config, pkgs, ... }:
{
    imports = [
        ./extenal_sources.nix
        ./rip.nix
        ./rmpc.nix
        ./mpd.nix
    ];
}
