{ pkgs, lib, config, ... }:
let
    cfg = config.settings.home.theme;
in
{
    config = lib.mkIf cfg {
        gtk = {
            enable = true;
            theme = {
                name = "Nordic";
                package = pkgs.nordic;
            };
            iconTheme = {
                name = "breeze";
            };
            font = {
                name = "CodeNewRoman";
                package = pkgs.nerd-fonts.code-new-roman;
            };
        };
    };
}
