{ lib, config, pkgs, ... }:

let
  cfg = config.settings.home.terminal.terminals;
  colours = import ../../../values/colours.nix;

  alacrittyConfig = {
        enable = true;
        package = pkgs.alacritty;
        settings = {
            terminal.shell = "${pkgs.zsh}/bin/zsh";
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

  kittyConfig = {
    enable = true;
    package = pkgs.kitty;
    font = {
    name = "CodeNewRoman";
    size = 12;
    };

    extraConfig = "
        background #222244
        shell zsh
        confirm_os_window_close 0
    ";
  };

in
with lib;
{
  config = mkMerge [
    ( mkIf cfg.alacritty { programs.alacritty = alacrittyConfig; } )
    ( mkIf cfg.kitty { programs.kitty = kittyConfig; } )
  ];   
}
