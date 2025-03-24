{ local, ... }:

{
    system.stateVersion = local.stable_version;

    imports = [
        ../options.nix
        ../settings.nix

        ../host/hardware-configuration.nix
        
        ./de
        ./display_managers
        ./keyboard
        ./services
        ./system
    ];
}
