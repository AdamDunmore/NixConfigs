{ inputs, font, pkgs, pkgs-stable, lib, config, ... }:
let
    cfg = config.settings.nixos.system.enable;
    cosmic_cfg = config.settings.home.wm.cosmic;
    cfg_apps = config.settings.home.apps;
    wm_cfg = config.settings.home.wm.defaults;
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
            fonts.packages = [ font.pkg ];

            #Enables Flatpak
            services.flatpak.enable = true;

            #Gnome keyring
            services.gnome.gnome-keyring.enable = true;
            security.polkit.enable = true;
            security.pam.services.login.enableGnomeKeyring = true;
            security.pam.services.hyprlock.enableGnomeKeyring = mkIf (wm_cfg.locker == pkgs.hyprlock) true;
            security.pam.services.swaylock.enableGnomeKeyring = mkIf (wm_cfg.locker == pkgs.swaylock) true;
            security.pam.services.sddm.enableGnomeKeyring = mkIf (config.settings.nixos.display_manager == "sddm") true;

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
            services.mpdscribble = mkIf config.settings.home.apps.music.enable {
                enable = true;
                endpoints."last.fm" = {
                    passwordFile = config.sops.secrets.lastfm_pass.path;                
                    username = "SkinnySheev";
                };
            };


            # Moves pkgs to stable 
            boot.kernelPackages = pkgs-stable.linuxPackages_latest;
            
            # Default ssh settings
            services.openssh.enable = lib.mkDefault false;
            programs.ssh.askPassword = "";
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

        ( mkIf (cfg_apps.level == "light" || cfg_apps.level == "all") {
            programs.steam = {
                enable = true;
                remotePlay.openFirewall = true;
                dedicatedServer.openFirewall = true; 
            };
        } )
    ];
}
