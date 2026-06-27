{ pkgs, lib, ... }:

{
    config.settings = lib.mkDefault {
        home = {
            apps = {
                level = "light";
            };
            terminal = {
                editors.emacs = true;
                terminals.ghostty = true; # Testing
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
                    terminal = pkgs.ghostty;
                };
                sway.enable = true;
                mango.enable = true;
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
                ai = true;
                syncthing = true;
                tailscale = true;
            };
        };
    };
}
