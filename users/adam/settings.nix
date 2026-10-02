{ pkgs, config, user, ... }:

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
                    apps.misc.discord.flavour = "concord";
                    terminal.shell.zellij.enable = true;
                    terminal.editors.nvim = {
                        enable = true;
                        ai = false;
                        localPath = "/home/${user}/Projects/NvimConfigs";
                    };
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
