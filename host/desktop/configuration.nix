{ pkgs, inputs, ... }:

{
    networking.hostName = "desktop";

    # Enables AMD GPU drivers
    boot.initrd.kernelModules = [ "amdgpu" ];
    services.xserver.videoDrivers = [ "amdgpu" ];
    hardware = {
        logitech.wireless = {
            enable = true;
            enableGraphical = true;
        };
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

    # Add ntfs support
    boot.supportedFilesystems = [ "ntfs" ];

    boot.loader.grub.efiSupport = true;
}
