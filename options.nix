{ lib, pkgs, ... }:

with lib;
let
  falseEnableOption = s: mkOption {
    type = types.bool;
    default = true;
    example = false;
    description = s;
  };
in
{
    options.settings = {
        home = {
            apps = {
                level = mkOption {
                    type = types.enum [ "all" "light" "minimal" ];
                    default = "minimal";
                    example = "all";
                    description = "String value for what app package to install. Possible options are 'all', 'light' or 'minimal'.";
                };
            };

            scripts = falseEnableOption "Enable scripts module";
            terminal = {
                editors = {
                    emacs = mkEnableOption "Enables Emacs";
                    nvim = falseEnableOption "Enables Nvim";
                };
                shell.enable = falseEnableOption "Enables Shell modules";
                terminals = {
                    alacritty = mkEnableOption "Enables Alacritty";
                    kitty = mkEnableOption "Enables Kitty";
                };
            };
            widgets = {
                mako = mkEnableOption "Enables Mako";
                waybar = mkEnableOption "Enables Waybar";
                wofi = mkEnableOption "Enables Wofi";
            };
            wm = {
                default = mkOption {
                    type = types.str;
                    default = "${pkgs.i3}/bin/i3";
                    example = "\${pkgs.i3}/bin/i3";
                    description = "The binary for your default Window Manager/Compositor";
                };

                default_locker = mkOption {
                    type = types.str;
                    default = "${pkgs.swaylock}/bin/swaylock";
                    example = "\${pkgs.swaylock}/bin/swaylock";
                    description = "The binary for your default Wayland locker";
                };

                hyprland = {
                    enable = mkEnableOption "Enables Hyprland";
                    hyprlock = mkEnableOption "Enables Hyprlock";
                };

                river = {
                    enable = mkEnableOption "Enables River";
                };

                sway = {
                    enable = mkEnableOption "Enables Sway";
                    swaylock = mkEnableOption "Enables Swaylock";
                };
            };
        };

        nixos = {
            de = {
                gnome = mkEnableOption "Enables Gnome";
                plasma = mkEnableOption "Enables Plasma";

            };
            display_manager = mkOption {
                type = types.enum [ "greetd" "ly" "sddm" ];
                default = "greetd";
                example = "sddm";
                description = "String value for what display manager to use. Possible options are 'greetd', 'ly' or 'sddm'.";
            };
            keyboard = {
                enable = mkEnableOption "Enable Configuring Keyboard";
                custom_layout = mkEnableOption "Enable Custom Keyboard Layout";
            };
            services = {
                syncthing = mkEnableOption "Enable Syncthing";
            };
        };
    };
}
