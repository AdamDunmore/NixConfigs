{ pkgs, lib, config, ... }:
let
    cfg = config.settings.nixos.system.enable;
    cosmic_cfg = config.settings.home.wm.cosmic;
    inherit (lib) mkIf mkMerge;
in
{
    config = mkMerge [
        ( mkIf cfg { 
            # Services (Mainly for AGS)
            services = {
                libinput.enable = true;
                printing.enable = true;
                power-profiles-daemon.enable = true;
                gvfs.enable = true;
            };

            # Enable networking
            networking.networkmanager.enable = true;
            hardware.wirelessRegulatoryDatabase = true;
            boot.extraModprobeConfig = ''
                options cfg80211 ieee80211_regdom="GB"
            '';

            # Downloading Nerd Font
            fonts.packages = with pkgs; [
                nerd-fonts.code-new-roman
            ];


            #Enables Flatpak
            services.flatpak.enable = true;

            #Enables Hyprlock
            security.polkit.enable = true;
            security.pam.services.hyprlock = {};
            security.pam.services.swaylock = {};

            # Garbage Collection
            nix.gc = {
                automatic = true;
                options = "--delete-older-than 30d";
            };

            # Man pages
            documentation.dev.enable = true;

            # Enables Dconf
            programs.dconf.enable = true;

            # Enables flakes
            nix.settings.experimental-features = [ "nix-command" "flakes" ];

            #XDG Setup
            xdg = {
                portal = {
                    enable = true;
                    xdgOpenUsePortal = true;
                    wlr.enable = true;
                    config.common.default = "*";
                    extraPortals = with pkgs; [ 
                        xdg-desktop-portal-gtk
                        xdg-desktop-portal-wlr
                    ];
                };
            };

            # Enable FUSE                
            programs.fuse = {
              # enable = true;
              userAllowOther = true;
            };

            # Music scrobbling
            services.mpdscribble = mkIf config.settings.home.apps.music {
                enable = true;
                endpoints."last.fm" = {
                    passwordFile = config.sops.secrets.lastfm_pass.path;                
                    username = "SkinnySheev";
                };
            };
        } )
        
        ( mkIf cosmic_cfg.enable {
            services.desktopManager.cosmic = {
                enable = true;
                xwayland.enable = true;
            };
        } ) 

        ( mkIf cosmic_cfg.cosmic-greeter {
            services.displayManager.cosmic-greeter.enable = true;
        } ) 
    ];
}
