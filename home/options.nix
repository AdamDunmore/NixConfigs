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
        };

        nixos = {
            display_managers = {
              greetd = mkEnableOption "Enable Greetd";
              ly = mkEnableOption "Enable Ly";
              sddm = mkEnableOption "Enable SDDM";
            };
        };
    apps = {
        all = mkEnableOption "Install all apps";
        light = mkEnableOption "Install all light apps";
        minimal = mkEnableOption "Install all minimal apps";
    };

    services = {
        syncthing = mkEnableOption "Enable Syncthing";
    };

    scripts = mkEnableOption "Enable Scripts";

    keyboard = {
        enable = mkEnableOption "Enable Configuring Keyboard";
        custom_layout = mkEnableOption "Enable Custom Keyboard Layout";
    };

    terminal = {
      editors = {
        default = mkOption {
            type = types.str;
            default = "${pkgs.nano}/bin/nano";
            example = "\${pkgs.nano}/bin/nano";
            description = "The binary for your default editor";
        };

        emacs = mkEnableOption "Enable Emacs";
        nvim = mkEnableOption "Enable Neovim";
      };
      shell = {
        enable = mkEnableOption "Enable Shell Configuration";
        tmux = mkEnableOption "Enable Tmux Configuration";
        zellij = mkEnableOption "Enable Zellij Configuration";
      };
      terminals = {
        default = mkOption {
            type = types.str;
            default = "${pkgs.foot}/bin/foot";
            example = "\${pkgs.foot}/bin/foot";
            description = "The binary for your default terminal";
        };

        alacritty = mkEnableOption "Enable Alacritty";
        kitty = mkEnableOption "Enable Kitty";
      };
    };
    wm = {
      widgets = { 
        ags = {
            enable = mkEnableOption "Enable Ags"; #TODO: Divide into modules
        };

        mako = mkEnableOption "Enable Mako";
        waybar = mkEnableOption "Enable Waybar";
        wofi = mkEnableOption "Enable Wofi";
      };
      window_managers = {
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
            enable = mkEnableOption "Enable Hyprland";
            hyprlock = mkEnableOption "Enable Hyprlock";
        };

        river.enable = mkEnableOption "Enable River";

        sway = {
            enable = mkEnableOption "Enable Sway";
            swaylock = mkEnableOption "Enable Swaylock";
        };
      };
    };
  };
}
