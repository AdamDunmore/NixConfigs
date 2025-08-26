{ lib, ... }:
{
    config.settings = lib.mkForce {
        home = {
            apps = {
                autostart.enable = false;
                level = "minimal";
                music = false; 
            };
            scripts = false;
            terminal = {
                editors = {
                    nvim = true;
                    emacs = false;
                };
                terminals.alacritty = false;
            };
            wm = {
                sway.enable = false;
                hyprland.hyprlock = false;
            };
        };
        nixos = {
            display_manager = "none";
            services = {
                syncthing = true;
                tailscale = true;
            };
            system = {
                bootloader = false;
                virtualisation = false;
            };
        };
    };
}
