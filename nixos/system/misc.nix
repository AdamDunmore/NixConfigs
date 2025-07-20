{ pkgs, lib, config, ... }:
let
    cfg = config.settings.nixos.system.enable;
in
{
    config = lib.mkIf cfg {
        # Services (Mainly for AGS)
        services = {
            libinput.enable = true;
            printing.enable = true;
            power-profiles-daemon.enable = true;
            gvfs.enable = true;
        };

        # Enable networking
        networking.networkmanager.enable = true;

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
    };
}
