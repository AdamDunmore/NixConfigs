{ lib, pkgs, ... }:

with lib;
{
    options.adam = {
        home = {
            apps = {
                level = mkOption {
                    type = type.enum [ "all" "light" "minimal" ];
                    default = "minimal";
                    example = "all";
                    description = "String value for what app package to install. Possible options are 'all', 'light' or 'minimal'.";
                };
            };

            scripts = mkEnableOption "Enable scripts module";
            terminal = {
                editors = {
                    emacs = mkEnableOption "Enables Emacs";
                    nvim = mkEnableOption "Enables Nvim";
                };
                shell.enable = mkEnableOption "Enables Shell modules";
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
            display_managers = {
              greetd = mkEnableOption "Enable Greetd";
              ly = mkEnableOption "Enable Ly";
              sddm = mkEnableOption "Enable SDDM";
            };
        };
    
        services = {
            syncthing = mkEnableOption "Enable Syncthing";
        };

        keyboard = {
            enable = mkEnableOption "Enable Configuring Keyboard";
            custom_layout = mkEnableOption "Enable Custom Keyboard Layout";
        };
  };
}
