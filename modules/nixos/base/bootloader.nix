{ lib, config, pkgs, ... }:
let
    cfg = config.settings.modules.nixos.base.bootloader;
    inherit (lib) mkIf;
in
{
    config = mkIf cfg.enable {
        boot.loader = {
            efi.canTouchEfiVariables = true;
            timeout = 3;
            grub = {
                enable = true;
                theme = pkgs.minimal-grub-theme; 
                device = "nodev";
                useOSProber = true;
                efiInstallAsRemovable = false;
            };
            systemd-boot.enable = false;   
        };

        # Custom boot screen
        boot.initrd.systemd.enable = true;
        boot.kernelParams = [ "quiet" "splash" "loglevel=3" ];
        boot.plymouth = {
          enable = true;
            theme = "fade-in";
            logo = "${pkgs.nixos-icons}/share/icons/hicolor/256x256/apps/nix-snowflake.png";
        };
    };
}
