{ lib, config, ... }:

let
    cfg = config.settings.modules.nixos.keyboard;
    inherit (lib) mkIf;
in
{
    imports = [ 
        ./mappings.nix
    ];

    config = mkIf cfg.enable {
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
