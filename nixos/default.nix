{ host, pkgs, ... }:

{
    config = {
        system.stateVersion = "24.11";

        # Enables Lix
        # nix.package = pkgs.lixPackageSets.stable.lix;
    };

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
