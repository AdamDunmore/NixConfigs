{ inputs, lib, config, user, ... }:
let
    cfg = config.settings.modules.home;
    inherit (lib) mkForce mkIf;
in
{
    imports = [
        inputs.sops-nix.homeManagerModules.sops

        ./apps
        ./terminal
        ./wm
    ];

    config = mkIf cfg.enable {
        home.username = mkForce user; 
        home.homeDirectory = mkForce "/home/${user}";
        home.stateVersion = mkForce "24.11";

        xdg.enable = true;
        xdg.userDirs = {
            enable = true;
            createDirectories = true;
            extraConfig = {
                DIRECTORY_MODE = "0755";
            };
        };

        # Setup sops for hm
        sops = {
            age.keyFile = "/etc/age.key";
            defaultSopsFile = ../../users/${user}/secrets/secrets.yaml;
        };
    };
}
