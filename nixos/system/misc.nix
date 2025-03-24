{ pkgs, ... }:

{
    config = {
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
        # fonts.packages = with pkgs; [
        #     (nerdfonts.override { fonts = [ "CodeNewRoman" ]; })
        # ];
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

        # Enables xdg portals
        xdg.portal = {
            enable = true;
            wlr.enable = true;
        };

        # Enables Dconf
        programs.dconf.enable = true;
    };
}
