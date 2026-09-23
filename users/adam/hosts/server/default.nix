{ ... }:
{
    imports = [
        ../../secrets
        ../../configuration.nix
        ./configuration.nix
        ./hardware-configuration.nix
    ];
    config = {
        system.stateVersion = "26.05";
    };
}
