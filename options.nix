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
                autostart = {
                    enable = falseEnableOption "Enables autostart";
                    apps = mkOption {
                        type = types.listOf types.package;
                        default = [];
                        example = "[ pkgs.spotify pkgs.steam ]";
                        description = "A list of packages to start we autostart is run";
                    };
                    runOnBoot = mkEnableOption "Enables autostart running on boot";
                };
                level = mkOption {
                    type = types.enum [ "all" "light" "minimal" ];
                    default = "minimal";
                    example = "all";
                    description = "String value for what app package to install. Possible options are 'all', 'light' or 'minimal'.";
                };
                music = falseEnableOption "Enables music";
            };

            scripts = falseEnableOption "Enable scripts module";
            terminal = {
                editors = {
                    emacs = mkEnableOption "Enables Emacs";
                    nvim = falseEnableOption "Enables Nvim";
                };
                shell = {
                    ai = falseEnableOption "Enables ai";
                    lsd = falseEnableOption "Enables lsd";
                    git = falseEnableOption "Enables git";
                    starship = falseEnableOption "Enables starship";
                    tmux = mkEnableOption "Enables tmux";
                    yazi = falseEnableOption "Enables yazi";
                    zellij = mkEnableOption "Enables zellij";
                    zoxide = falseEnableOption "Enables zoxide (z)"; 
                    zsh = falseEnableOption "Enables zsh";
                };
                terminals = {
                    alacritty = mkEnableOption "Enables Alacritty";
                    kitty = mkEnableOption "Enables Kitty";
                };
            };
            theme = falseEnableOption "Enables theme modules";
            widgets = {
                ags = mkEnableOption "Enables ags";
                mako = mkEnableOption "Enables Mako";
                waybar = mkEnableOption "Enables Waybar";
                wofi = mkEnableOption "Enables Wofi";
            };
            wm = {
                defaults = {
                    wm =  mkOption {
                        type = types.package;
                        default = pkgs.i3;
                        example = pkgs.i3;
                        description = "The package for your default Window Manager/Compositor";
                    };

                    locker = mkOption {
                        type = types.package;
                        default = pkgs.swaylock;
                        example = pkgs.swaylock;
                        description = "The package for your default locker";
                    };

                    terminal = mkOption { 
                        type = types.package;
                        default = pkgs.kitty;
                        example = pkgs.kitty;
                        description = "The package for your default terminal";
                    };
                };

                cosmic = {
                    enable = mkEnableOption "Enables Cosmic";
                    cosmic-greeter = mkEnableOption "Enables Cosmic Greeter";
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
                type = types.enum [ "greetd" "ly" "sddm" "none" ];
                default = "greetd";
                example = "sddm";
                description = "String value for what display manager to use. Possible options are 'greetd', 'ly', 'sddm' or 'none'.";
            };
            keyboard = {
                enable = falseEnableOption "Enable Configuring Keyboard";
                custom_layout = falseEnableOption "Enable Custom Keyboard Layout";
            };
            services = {
                syncthing = mkEnableOption "Enable Syncthing";
                tailscale = mkEnableOption "Enable Tailscale";
            };
            steamdeck = {
                enable = mkEnableOption "Enables steamdeck module";
            };
            system = { 
                enable = falseEnableOption "Enables system modules";
                bootloader = falseEnableOption "Enables bootloader module";
                secrets = falseEnableOption "Enables secrets module";
                virtualisation = falseEnableOption "Enables virtualbox";
            };
        };
    };
}
