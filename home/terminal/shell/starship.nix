{ lib, config, colours, ... }:

let
  cfg = config.settings.home.terminal.shell.starship;
in
with lib;
{
    config = mkIf cfg {
        programs.starship = {
            enable = true;
            enableZshIntegration = true;
            settings = {
                format = "[ ](${colours.light_blue.one})$username[](fg:${colours.light_blue.one} bg:${colours.blue.one})$hostname[](fg:${colours.blue.one} bg:${colours.light_blue.two})$directory[ ](${colours.light_blue.two})";
                add_newline = false;
                username = {
                    style_user = "bg:${colours.light_blue.one} fg:${colours.white.one}";
                    disabled = false;
                    show_always = true;
                    format = "[$user ]($style)";
                };
                hostname = {
                    format = "[ $hostname ]($style)"; 
                    style = "bg:${colours.blue.one} fg:${colours.white.one}";
                    ssh_only = true;
                };
                directory = {
                    format = "[ $path ]($style)";
                    style = "bg:${colours.light_blue.two} fg:${colours.white.one}";
                };
            };
        };
    };
}
