{ pkgs, inputs, ... }: 

{
    imports = [ inputs.nixos-hardware.nixosModules.framework-13-7040-amd ];

    config = {
        networking.hostName = "laptop";
        boot.loader.grub.efiSupport = true;

        hardware.framework.enableKmod = true;

        # Locks regulatory code to GB
        boot.kernelParams = [
          "cfg80211_ieee80211_regdom=GB"
          "cfg80211_reg_ignore_hints=1"
        ];

        networking.networkmanager.settings.main.no-auto-default = true;

        # Sets up fprint
        services.fprintd = {
            enable = true;
        };

        security.pam.services = {
            login.fprintAuth = true;  
            # sudo.fprintAuth = true;
            sddm.fprintAuth = true;      
            hyprlock.fprintAuth = true;  
        };

        # Enables AMD GPU drivers
        hardware.amdgpu.initrd.enable = true;
        boot.initrd.kernelModules = [ "amdgpu" ];
        services.xserver.videoDrivers = [ "amdgpu" ];
        hardware.graphics = {
            enable = true;
            extraPackages = with pkgs; [
                mesa
                vulkan-loader
                vulkan-validation-layers
                vulkan-extension-layer
            ];
            enable32Bit = true; # Needed for steam
        };
    };
}
