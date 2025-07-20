{ local, lib, host, ... }:
with lib;
{
    config = {
        home.username = mkForce local.username; 
        home.homeDirectory = mkForce "/home/${local.username}";
        home.stateVersion = mkForce local.stable_version;

        xdg.userDirs = {
            enable = true;
            createDirectories = true;
        };
    };

    imports = [
        ../options.nix
        ../settings.nix
        ../host/${host}/settings.nix

        ./apps
        ./scripts
        ./terminal
        ./theme
        ./widgets
        ./wm
    ];
}
