{ lib, pkgs, config, ... }:

let
    cfg = config.settings.modules.nixos.display_managers;
    cfg_wm = config.settings.modules.home.wm;
    inherit (lib) mkIf;
in
{
    imports = [
        ./greetd
        ./ly.nix
        ./sddm.nix
    ];

    config = mkIf cfg.enable {
        services.displayManager = {
            sessionPackages = with pkgs; [
                ( lib.mkIf cfg_wm.sway.enable swayfx)
                ( lib.mkIf cfg_wm.hyprland.enable hyprland)
                ( lib.mkIf cfg_wm.river.enable river)
            ];
        };
    };
}
