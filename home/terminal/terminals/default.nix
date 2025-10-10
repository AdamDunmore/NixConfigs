{ lib, config, pkgs, colours, font, ... }:

let
  cfg = config.settings.home.terminal.terminals;
  inherit (lib) mkIf mkMerge;
in
{
  config = mkMerge [
    ( mkIf cfg.alacritty { 
        programs.alacritty = {
            enable = true;
            package = pkgs.alacritty;
            settings = {
                terminal.shell = mkIf config.settings.home.terminal.shell.zsh "${pkgs.zsh}/bin/zsh";
                colors = {
                    primary = {
                        background = "${colours.blue.three}";
                        foreground = "${colours.white.one}";
                    };
                };
                keyboard.bindings = [
                        { key = "N"; mods = "Control"; action = "ToggleFullscreen"; }
                        # { key = "E"; mods = "Control"; command = "${pkgs.neovim}/bin/nvim"; }
                ];
            };
        }; 
    } )
    ( mkIf cfg.kitty { 
        programs.kitty = {
            enable = true;
            package = pkgs.kitty;
            font = {
                name = font.name;
                size = 12;
            };

            extraConfig = "
                background #222244
                ${(mkIf config.settings.home.terminal.shell.zsh "shell zsh")}
                confirm_os_window_close 0
            ";
        };
    } )
  ];   
}
