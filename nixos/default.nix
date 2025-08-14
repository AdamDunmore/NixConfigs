{ local, host, config, ... }:

{
    system.stateVersion = local.stable_version;

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
