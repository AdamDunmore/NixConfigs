{ pkgs, lib, config, ... }:

let
    cfg = config.settings.nixos.display_manager;
in
{
    config = lib.mkIf (cfg == "sddm") {
        services.displayManager.sddm = {
            enable = true;
            package = pkgs.qt6Packages.sddm;
            wayland.enable = true;
            settings = {};
            theme = "sddm-astronaut-theme";
            extraPackages = [ pkgs.sddm-astronaut ];
        };
    };
}
