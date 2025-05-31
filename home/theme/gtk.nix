{ pkgs, lib, config, font, ... }:
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
                name = font.name;
                package = pkgs.nerd-fonts.code-new-roman;
            };
        };
    };
}
