{ lib, config, ... }:

let
  cfg = config.adam.terminal.shell.enable;
  colours = import ../../../../values/colours.nix;
in
with lib;
{
    config = mkIf cfg {
        programs.starship = {
            enable = true;
            enableZshIntegration = true;
            settings = {
                format = "[ ](${colours.light_blue.one})$username[](fg:${colours.light_blue.one} bg:${colours.light_blue.two})$directory[ ](${colours.light_blue.two})";
                add_newline = false;
                username = {
                    style_user = "bg:${colours.light_blue.one} fg:${colours.white.one}";
                    disabled = false;
                    show_always = true;
                    format = "[$user ]($style)";
                };
                directory = {
                    format = "[ $path ]($style)";
                    style = "bg:${colours.light_blue.two} fg:${colours.white.one}";
                };
            };
        };
    };
}
