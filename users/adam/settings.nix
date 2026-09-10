{ pkgs, ... }:

{
    imports = [
        ./apps.nix
    ];
    config = {
        settings = {
           modules = {
                enable = true;
                nixos = {
                    services.ai.enable = false;
                };
                home = {
                    apps.media.kodi.enable = false;
                    terminal.shell.zellij.enable = true;
                    wm = {
                        defaults = {
                            locker = pkgs.hyprlock;
                            terminal = pkgs.ghostty;
                        };
                        mango.enable = true;
                        hyprland.hyprlock.enable = true;
                    };
                };
           }; 
        };        
    };
}
