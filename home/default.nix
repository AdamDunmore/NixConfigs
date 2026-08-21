{ inputs, lib, host, config, user, ... }:
let
    inherit (lib) mkIf mkForce;
in
{
    imports = [
        inputs.sops-nix.homeManagerModules.sops
        
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

    config = {
        home.username = mkForce user; 
        home.homeDirectory = mkForce "/home/${user}";
        home.stateVersion = mkForce "24.11";

        xdg.enable = true;
        xdg.userDirs = mkIf (config.settings.home.apps.level == "minimal") {
            enable = true;
            createDirectories = true;
            extraConfig = {
                DIRECTORY_MODE = "0755";
            };
        };

        # Setup sops for hm
        sops = {
            age.keyFile = "/etc/age.key";
            defaultSopsFile = ../nixos/system/secrets/secrets.yaml;
        };
    };
}
