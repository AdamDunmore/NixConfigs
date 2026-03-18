{ pkgs, lib, config, ... }:

let
    cfg = config.settings.nixos.display_manager;
in
{
    config = lib.mkIf (cfg == "sddm") {
        services.displayManager.sddm = {
            enable = true;
            wayland.enable = false; #TODO fix for no mouse in SDDM
            extraPackages = [
                pkgs.kdePackages.qtmultimedia
            ];
            settings = {
                General = {
                    InputMethod = "";
                };
            };
            theme = "sddm-astronaut-theme";
        };


        environment.systemPackages = [ 
            pkgs.sddm-astronaut 
        ];
    };
}
