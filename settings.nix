{ pkgs, ... }:

{
    settings = {
        home = {
            apps.level = "light";
            scripts = true;
            terminal = {
                editors = {
                    emacs = true;
                    nvim = true;
                };
                shell.enable = true;
                terminal.alacritty = true;
                widgets = {
                    mako = true;
                    waybar = true;
                    wofi = true;
                };
                wm = {
                    default = "${pkgs.swayfx}/bin/sway";
                    default_locker = "${pkgs.hyprlock}/bin/hyprlock";
                    sway.enable = true;
                    hyprland.hyprlock = true;
                };
            };
        };    
    };
}
