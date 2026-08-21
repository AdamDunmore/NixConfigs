{ lib, config, pkgs, ... }:

let
    cfg = config.settings.modules.home.terminal.shell.tmux;
    inherit (lib) mkIf;
in
{
    config = mkIf cfg.enable {
        programs.tmux = {
            enable = true;
            clock24 = true;
            mouse = true;
            prefix = "C-r";
            shell = mkIf config.settings.modules.home.terminal.shell.zsh.enable "${pkgs.zsh}/bin/zsh";
            terminal = "screen-256color";
        };
    };
}
