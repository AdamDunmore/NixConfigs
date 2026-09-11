{ lib, config, ... }:

let
    cfg = config.settings.modules.home.terminal.shell.starship;
    colours = config.settings.values.colours;
    inherit (lib) mkIf;
in
{
    config = mkIf cfg.enable {
        programs.starship = {
            enable = true;
            enableZshIntegration = config.settings.modules.home.terminal.shell.zsh.enable;
            settings = {
                format = "[ ](${colours.bg_selected})$username[](fg:${colours.bg_selected} bg:${colours.bg})$hostname[](fg:${colours.bg} bg:${colours.bg_selected})$directory[ ](${colours.bg_selected})";
                add_newline = false;
                username = {
                    style_user = "bg:${colours.bg_selected} fg:${colours.fg}";
                    disabled = false;
                    show_always = true;
                    format = "[$user ]($style)";
                };
                hostname = {
                    format = "[ $hostname ]($style)"; 
                    style = "bg:${colours.bg} fg:${colours.fg}";
                    ssh_only = true;
                };
                directory = {
                    format = "[ $path ]($style)";
                    style = "bg:${colours.bg_selected} fg:${colours.fg}";
                };
            };
        };
    };
}
