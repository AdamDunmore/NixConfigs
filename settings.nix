{ pkgs, lib, ... }:

{
    config.settings = lib.mkDefault {
        home = {
            apps = {
                level = "light";
                browser.brave = true;
            };
            terminal = {
                editors.emacs = true;
                terminals.alacritty = true;
                shell.zellij = true;
            };
            widgets = {
                ags = true;
                mako = true;
                waybar = true;
                wofi = true;
            };
            wm = {
                defaults = {
                    wm = pkgs.swayfx;
                    locker = pkgs.hyprlock;
                    terminal = pkgs.alacritty;
                };
                sway.enable = true;
                hyprland.hyprlock = true;
            };
        };    
        nixos = {
            display_manager = "sddm";
            keyboard = {
                enable = true;
                custom_layout = true;
            };
            services = {
                syncthing = true;
                tailscale = true;
            };
        };
    };
}
