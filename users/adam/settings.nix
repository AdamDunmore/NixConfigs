{ pkgs, ... }:

{
    imports = [
        ./apps.nix
    ];
    config = {
        settings = {
           modules = {
                enable = true;
                nixos.base = {
                    secrets.user_password = false; # TODO change when in live
                };
                home = {
                    apps.media.kodi.enable = true;
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
