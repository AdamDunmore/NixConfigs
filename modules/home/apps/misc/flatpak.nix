{ inputs, config, lib, ... }:
let
    cfg = config.settings.modules.home.apps.misc.flatpak;
    inherit (lib) mkIf;
in
{
    imports = [ inputs.nix-flatpak.homeManagerModules.nix-flatpak ];
    config = mkIf cfg.enable {
        services.flatpak = {
            enable = true;
            packages = cfg.packages; 
        };
    };
}
