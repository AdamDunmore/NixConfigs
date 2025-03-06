{ local, ... }:
{
    config = {
        home.username = local.username; 
        home.homeDirectory = "/home/${local.username}";
        home.stateVersion = local.stable_version;
    };

    imports = [
        ./options.nix
        ../settings.nix

        ./apps
        ./scripts
        ./terminal
        ./widgets
        ./wm
    ];
}
