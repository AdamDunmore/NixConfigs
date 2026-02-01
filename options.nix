{ config, lib, pkgs, ... }:
let
    inherit (lib) mkOption types mkEnableOption;

    mkDefaultOption = s: d: mkOption {
        type = types.bool;
        default = d;
        example = false;
        description = s;
    };
    cfg = config.settings; 
in
{
    options.settings = {
        home = {
            apps = {
                autostart = {
                    enable = mkDefaultOption "Enables autostart" true;
                    apps = mkOption {
                        type = types.listOf types.package;
                        default = [];
                        example = "[ pkgs.spotify pkgs.steam ]";
                        description = "A list of packages to start we autostart is run";
                    };
                    runOnBoot = mkEnableOption "Enables autostart running on boot";
                };
                browser = {
                    brave = mkEnableOption "Enables Brave";
                    firefox = mkEnableOption "Enables firefox";
                    default = mkOption {
                        type = types.enum [ "brave" "firefox" ];
                        default = "firefox";
                        example = "brave";
                        description = "Sets the default browser for the system";
                    };
                };

                level = mkOption {
                    type = types.enum [ "all" "light" "minimal" ];
                    default = "minimal";
                    example = "all";
                    description = "String value for what app package to install. Possible options are 'all', 'light' or 'minimal'.";
                };

                misc = {
                    code = mkEnableOption "Enables VSCode";
                    flatpak = mkDefaultOption "Enables Flatpak" true;
                };

                music = {
                    enable = mkDefaultOption "Enables music listening module" true;
                    path = mkOption {
                        type = types.str; 
                        default = "${config.home.homeDirectory}/Music";
                        example = "/mnt/Drive1/Music";
                        description = "The path for your library";
                    };
                    sources = {
                        nextcloud = mkEnableOption "Enable nextcloud source";
                        webdav = mkEnableOption "Enable webdav source";
                    };
                    spotify = mkEnableOption "Enables Spotify";
                };
            };

            scripts = mkDefaultOption "Enable scripts module" true;
            terminal = {
                editors = {
                    emacs = mkEnableOption "Enables Emacs";
                    nvim = mkDefaultOption "Enables Nvim" true;
                };
                shell = {
                    lsd = mkDefaultOption "Enables lsd" true;
                    intellishell = mkDefaultOption "Enables intellishell" true;
                    git = mkDefaultOption "Enables git" true;
                    starship = mkDefaultOption "Enables starship" true;
                    tmux = mkEnableOption "Enables tmux";
                    yazi = mkDefaultOption "Enables yazi" true;
                    zellij = mkEnableOption "Enables zellij";
                    zoxide = mkDefaultOption "Enables zoxide (z)" true; 
                    zsh = mkDefaultOption "Enables zsh" true;
                };
                terminals = {
                    alacritty = mkEnableOption "Enables Alacritty";
                    kitty = mkEnableOption "Enables Kitty";
                };
            };
            theme = mkDefaultOption "Enables theme modules" true;
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
                enable = mkDefaultOption "Enable Configuring Keyboard" true;
                custom_layout = mkDefaultOption "Enable Custom Keyboard Layout" true;
            };
            services = {
                nh = mkDefaultOption "Enables nh garbage collection" true;
                nextcloud = mkEnableOption "Enables nextcloud";
                mopidy = {
                    enable = mkEnableOption "Enable Mopidy";
                    path = mkOption {
                        type = types.str; 
                        default = config.settings.home.apps.music.path;
                        example = "~/Music";
                        description = "The path that mopidy-local uses";
                    };
                };
                jellyfin = mkEnableOption "Enable Jellyfin";  
                nginx = mkEnableOption "Enable Nginx";
                syncthing = mkEnableOption "Enable Syncthing";
                tailscale = mkEnableOption "Enable Tailscale";
            };
            steamdeck = {
                enable = mkEnableOption "Enables steamdeck module";
            };
            system = { 
                enable = mkDefaultOption "Enables system modules" true;
                bootloader = mkDefaultOption "Enables bootloader module" true;
                secrets = mkDefaultOption "Enables secrets module" true;
                virtualisation = mkEnableOption "Enables virtualbox";
            };
        };
    };
}
