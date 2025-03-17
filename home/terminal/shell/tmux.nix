{ lib, config, pkgs, ... }:

let
  cfg = config.settings.home.terminal.shell.enable;
in
with lib;
{
    config = mkIf cfg {
        programs.tmux = {
            enable = true;
            clock24 = true;
            mouse = true;
            prefix = "C-r";
            shell = "${pkgs.zsh}/bin/zsh";
            terminal = "screen-256color"; # Change if coulours are weird
        };
    };
}
