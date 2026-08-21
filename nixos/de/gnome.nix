{ pkgs, lib, config, ... }:

let
    cfg = config.settings.nixos.de.gnome;
in
{
    config = lib.mkMerge [
        ({ 
            environment.gnome.excludePackages = (with pkgs; [
              gnome-photos
              gnome-tour
              gedit
            ]) ++ (with pkgs; [
              gnome-music
              gnome-terminal
              epiphany
              geary
              evince
              gnome-characters
              tali
              iagno
              hitori
              atomix
              seahorse
            ]);
         })
        ( lib.mkIf cfg { services.xserver.desktopManager.gnome.enable = true; } )
    ]; 
}
