{ inputs, lib, config, pkgs, ... }:
let
    cfg = config.settings.modules.nixos.base;
    inherit (lib) mkIf mkMerge;
in
{
    imports =  [
        inputs.mango.nixosModules.mango-ext

        ./audio.nix
        ./bluetooth.nix
        ./bootloader.nix
        ./secrets.nix
        ./timezone.nix
        ./users.nix
        ./virtualisation.nix
    ]; 

    config = mkMerge [
        ( mkIf cfg.enable { 
            # Services (Mainly for AGS)
            services = {
                upower.enable = true;
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
            fonts.packages = [ config.settings.values.font.pkg ];

            #Enables Flatpak
            services.flatpak.enable = true;

            #Gnome keyring
            services.gnome.gnome-keyring.enable = true;
            security.polkit.enable = true;
            security.pam.services = let 
                wm_cfg = config.settings.modules.home.wm.defaults;
                dm_cfg = config.settings.modules.nixos.display_managers;
            in {
                login.enableGnomeKeyring = true;
                hyprlock.enableGnomeKeyring = mkIf (wm_cfg.locker == pkgs.hyprlock) true;
                swaylock.enableGnomeKeyring = mkIf (wm_cfg.locker == pkgs.swaylock) true;            
                sddm.enableGnomeKeyring = mkIf (dm_cfg.default == "sddm") true;
                # cosmic-greeter.enableGnomeKeyring = mkIf (config.settings.nixos.display_manager == "sddm") true;
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
              enable = true;
              userAllowOther = true;
            };

            # Enable Steam
            programs.steam = {
                enable = true;
                remotePlay.openFirewall = true;
                dedicatedServer.openFirewall = true; 
            };

            # Music scrobbling
            services.mpdscribble = mkIf config.settings.modules.home.apps.media.enable {
                enable = true;
                endpoints."last.fm" = {
                    passwordFile = config.sops.secrets.lastfm_pass.path;                
                    username = "SkinnySheev";
                };
            };

            # Moves pkgs to stable 
            # boot.kernelPackages = pkgs-stable.linuxPackages_latest; # TODO readd on kernel pkg update
            boot.kernelPackages = pkgs.linuxPackages_latest;
            
            # Default ssh settings
            services.openssh.enable = lib.mkDefault false;
            programs.ssh.askPassword = "";
        } )
        
        # ( mkIf (config.settings.nixos.display_manager == "cosmic") {
        #     services.displayManager.cosmic-greeter.enable = true;
        # } ) 

        ( mkIf config.settings.modules.home.wm.replays { 
            programs.gpu-screen-recorder.enable = true;
        })
        
        ( mkIf config.settings.modules.home.wm.mango.enable {
            programs.mango-ext.enable = true;
        })
    ];
}
