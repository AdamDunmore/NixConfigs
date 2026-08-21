{ lib, pkgs, ... }:
let
    inherit (lib) mkOption;
in
{
    options.settings.values.font = {
        name = mkOption {
            type = lib.types.str;
            default = "IntoneMono";
            example = "FiraMono";
            description = "Sets the system font name"; 
        };
        pkg = mkOption {
            type = lib.types.package;
            default = pkgs.nerd-fonts.intone-mono;
            example = pkgs.nerd-fonts.fira-mono;
            description = "Sets the system font package"; 
        };
    };
}
