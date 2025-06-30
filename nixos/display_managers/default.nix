{ lib, pkgs, config, ... }:

let
    wm_cfg = config.settings.home.wm;
in
{
    imports = [
        ./greetd
        ./ly.nix
        ./sddm.nix
    ];

    config = {
        # Sets up fprint
        services.fprintd = {
            enable = true;
        };

        
        security.pam.services = {
            login.fprintAuth = true;  
            # sudo.fprintAuth = true;
            sddm.fprintAuth = true;      
            hyprlock.fprintAuth = true;  
        };

        services.displayManager = {
            # defaultSession = "";
            sessionPackages = with pkgs; [
                ( lib.mkIf wm_cfg.sway.enable swayfx)
                ( lib.mkIf wm_cfg.hyprland.enable hyprland)
                ( lib.mkIf wm_cfg.river.enable river)
            ];
        };
    };
}
