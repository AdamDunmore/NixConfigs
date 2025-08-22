{ local, lib, host, config, ... }:
let
    inherit (lib) mkIf mkForce;
in
{
    config = {
        home.username = mkForce local.username; 
        home.homeDirectory = mkForce "/home/${local.username}";
        home.stateVersion = mkForce local.stable_version;

        xdg.userDirs = mkIf (config.settings.home.apps.level == "minimal") {
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
