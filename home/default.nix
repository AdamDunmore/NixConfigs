{ local, lib, ... }:
with lib;
{
    config = {
        home.username = mkForce local.username; 
        home.homeDirectory = mkForce "/home/${local.username}";
        home.stateVersion = mkForce local.stable_version;
    };

    imports = [
        ../options.nix
        ../settings.nix

        ./apps
        ./scripts
        ./terminal
        ./widgets
        ./wm
    ];
}
