{ pkgs, ... }: 

{
    networking.hostName = "laptop";
    boot.loader.grub.efiSupport = true;

    # Sets up fprint
    services.fprintd = {
        enable = true;
    };

    # Enables AMD GPU drivers
    boot.initrd.kernelModules = [ "amdgpu" ];
    services.xserver.videoDrivers = [ "amdgpu" ];
    hardware = {
        graphics = {
            enable = true;
            extraPackages = with pkgs; [
                vulkan-loader
                vulkan-validation-layers
                vulkan-extension-layer
            ];
            enable32Bit = true; # Needed for steam
        };
    };

    
    security.pam.services = {
        login.fprintAuth = true;  
        # sudo.fprintAuth = true;
        sddm.fprintAuth = true;      
        hyprlock.fprintAuth = true;  
    };
}
