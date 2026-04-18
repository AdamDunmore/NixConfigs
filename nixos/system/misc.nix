{ inputs, font, pkgs, pkgs-stable, lib, config, ... }:
let
    cfg = config.settings.nixos.system.enable;
    cfg_apps = config.settings.home.apps;
    inherit (lib) mkIf mkMerge;
in
{
    imports = [ inputs.mango.nixosModules.mango ];
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
            security.pam.services = let 
                wm_cfg = config.settings.home.wm.defaults; 
            in {
                login.enableGnomeKeyring = true;
                hyprlock.enableGnomeKeyring = mkIf (wm_cfg.locker == pkgs.hyprlock) true;
                swaylock.enableGnomeKeyring = mkIf (wm_cfg.locker == pkgs.swaylock) true;            
                sddm.enableGnomeKeyring = mkIf (config.settings.nixos.display_manager == "sddm") true;
                cosmic-greeter.enableGnomeKeyring = mkIf (config.settings.nixos.display_manager == "sddm") true;
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
                    xdgOpenUsePortal = false;
                    wlr.enable = true;
                    extraPortals = with pkgs; [ 
                        xdg-desktop-portal-gtk
                        xdg-desktop-portal-wlr
                    ];
                    config.common.default = [ "gtk" ];
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
        
        ( mkIf (config.settings.nixos.display_manager == "cosmic") {
            services.displayManager.cosmic-greeter.enable = true;
        } ) 

        ( mkIf (cfg_apps.level == "light" || cfg_apps.level == "all") {
            programs.steam = {
                enable = true;
                remotePlay.openFirewall = true;
                dedicatedServer.openFirewall = true; 
            };
        } )

        ( mkIf config.settings.home.wm.replays { 
            programs.gpu-screen-recorder.enable = true;
        })

        ( mkIf config.settings.home.wm.mango.enable {
            programs.mango.enable = true;
        })
    ];
}
