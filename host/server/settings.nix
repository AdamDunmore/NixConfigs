{ lib, ... }:
{
    config.settings = lib.mkForce {
        home = {
            apps = {
                autostart.enable = false;
                level = "minimal";
                music.enable = false; 
                music.path = "/mnt/MediaDrive/Music";
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
                jellyfin = true;
                # nginx = true;
                tailscale = true;
            };
            system = {
                bootloader = false;
                virtualisation = false;
            };
        };
    };
}
