{ pkgs, ... }:

{
    imports = [
        ./greetd
        ./ly.nix
        ./sddm.nix
    ];

    config = {
        services.displayManager = {
            # defaultSession = "";
            sessionPackages = with pkgs; [
                swayfx
                hyprland
                river
            ];
        };
    };
}
