{ host, ... }:

{
    system.stateVersion = "24.11";

    imports = [
        ../options.nix
        ../settings.nix
        ../host/${host}/settings.nix

        ./de
        ./display_managers
        ./keyboard
        ./services
        ./steamdeck
        ./system
    ];
}
