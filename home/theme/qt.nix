{ pkgs, lib, config, ... }:
let
    cfg = config.settings.nixos.theme;
in
{
    config = lib.mkIf cfg {
        qt = {
            enable = true;
            platformTheme.name = "gtk3";
            style = {
                name = "Nordic";
                package = pkgs.nordic;
            };
        };
    };
}
