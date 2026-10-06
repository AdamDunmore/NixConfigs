{ pkgs, lib, config, ... }:

let
    cfg = config.settings.modules.nixos.display_managers;
    inherit (lib) mkIf;
in
{
    config = mkIf (cfg.default == "sddm") {
        services.displayManager.sddm = {
            enable = true;
            wayland.enable = false; # TODO fix for no mouse in SDDM ( I think its something to do with the cursor theme
            # wayland.enable = true;
            extraPackages = [
                pkgs.kdePackages.qtmultimedia
            ];
            settings = {
                General = {
                    InputMethod = ""; # Disables virtual keyboard
                };
            };
            theme = "sddm-astronaut-theme";
        };


        environment.systemPackages = [ 
            pkgs.sddm-astronaut 
        ];
    };
}
