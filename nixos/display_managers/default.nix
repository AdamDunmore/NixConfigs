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
                ( lib.mkIf cfg.sway swayfx )
                ( lib.mkIf cfg.hyprland hyprland)
                ( lib.mkIf cfg.river river)
            ];
        };
    };
}
