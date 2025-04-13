{ lib, config, pkgs }:
let
    cfg = config.settings.home.terminal.editors.emacs;
in
{
    config = lib.mkIf cfg {
        programs.emacs = {
            enable = true;
            package = pkgs.emacs;
        };
        services.emacs.enable = true;

        home.file = {
            ".config/emacs/" = {
                 recursive = true;
                 source = ./.;
            };
        };
    };
}
