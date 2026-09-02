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
                    base = {
                        secrets.user_password = false; # TODO change when in live
                    };
                    services.ai.enable = true;
                };
                home = {
                    apps.media.kodi.enable = false;
                    terminal.shell.zellij.enable = true;
                    wm = {
                        shell.wofi.enable = true; # TODO remove when ags is tested
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
