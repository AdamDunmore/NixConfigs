{ lib, config, ... }:

let
  cfg = config.settings.nixos.keyboard.enable;
in
with lib;
{
    config = mkIf cfg {
        console.keyMap = "uk";
        services.xserver = {
            xkb = {
                variant = "";
                layout = "gb";
            };
            enable = true;
        };
    }; 
}
