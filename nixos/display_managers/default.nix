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
