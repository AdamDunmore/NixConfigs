{ inputs, pkgs, config, lib, ... }:
let
    cfg = config.settings.home.widgets.ags;
    inherit (lib) mkIf;
in
{
    imports = [ inputs.ags.homeManagerModules.default ];

    config = mkIf cfg {
        programs.ags = {
            enable = true;
            configDir = ./.;
            extraPackages = with pkgs.astal; [
                mpris
            ];
        };
    };
}
