{ pkgs, lib, config, ... }:
let
    inherit (lib) mkOption;
in
{
    imports = [
        ./shell
        ./theme
        ./hyprland.nix
        ./river.nix
        ./mango.nix
        ./sway.nix
    ];
    options.settings.modules.home.wm = {
        enable = mkOption {
            type = lib.types.bool;
            default = config.settings.modules.home.enable;
            example = false;
            description = "Enables the window manager modules";
        };
        replays = mkOption {
            type = lib.types.bool;
            default = false;
            example = true;
            description = "Enables the window manager replay module";
        };
        defaults = {
            wm =  mkOption {
                type = lib.types.package;
                default = pkgs.i3;
                example = pkgs.i3;
                description = "The package for your default Window Manager/Compositor";
            };

            locker = mkOption {
                type = lib.types.package;
                default = pkgs.swaylock;
                example = pkgs.swaylock;
                description = "The package for your default locker";
            };

            terminal = mkOption { 
                type = lib.types.package;
                default = pkgs.kitty;
                example = pkgs.kitty;
                description = "The package for your default terminal";
            };
        };
    };
}
