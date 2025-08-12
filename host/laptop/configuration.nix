{ pkgs, inputs, ... }: 

{
    imports = [ inputs.nixos-hardware.nixosModules.framework-13-7040-amd ];

    config = {
        networking.hostName = "laptop";
        boot.loader.grub.efiSupport = true;

        hardware.framework.enableKmod = true;

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
                amdvlk
                mesa
                vulkan-loader
                vulkan-validation-layers
                vulkan-extension-layer
            ];
            enable32Bit = true; # Needed for steam
        };
    };
}
