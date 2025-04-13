{ local, ... }:

{
    system.stateVersion = local.stable_version;

    imports = [
        ./de
        ./display_managers
        ./keyboard
        ./services
        ./system
    ];
}
