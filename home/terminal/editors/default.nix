{ lib, config, pkgs, ... }:

let
    cfg = config.settings.home.terminal.editors;
in
with lib;
{ 
    imports = [
        ./nvim.nix
    ];

    config = mkMerge [
        ( mkIf cfg.emacs {
            programs.emacs = {
                enable = true;
                package = pkgs.emacs;
            };
            services.emacs.enable = true;

            home.file = {
                ".config/emacs/" = {
                     recursive = true;
                     source = ./emacs;
                };
            };
        })
    ];   
}
