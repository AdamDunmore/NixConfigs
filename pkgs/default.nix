{ pkgs, ... }:
{
    amethyst = import ./amethyst.nix { inherit pkgs; };
    brave-origin = import ./brave-origin.nix { inherit pkgs; };
    jackify = import ./jackify.nix { inherit pkgs; };
    wfinfo-ng = import ./wfinfo-ng.nix { inherit pkgs; };
}
