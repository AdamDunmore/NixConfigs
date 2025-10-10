{ lib, config, ... }:

let
  cfg = config.settings.nixos.keyboard.enable;
  inherit (lib) mkIf;
in
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
