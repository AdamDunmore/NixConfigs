{ pkgs, ... }:

{
    config.settings = {
        home = {
            apps.level = "light";
            terminal = {
                editors.emacs = true;
                terminals.alacritty = true;
            };
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
        nixos = {
            display_manager = "sddm";
            keyboard = {
                enable = true;
                custom_layout = true;
            };
            #services.syncthing = true;
        };
    };
}
