{ pkgs, inputs, ... }:

{
    networking.hostName = "desktop";

    # Enables AMD GPU drivers

    environment.variables = {
        RADV_PERFTEST = "aco";
    };
    powerManagement.cpuFreqGovernor = "performance";

    services.xserver.videoDrivers = [ "amdgpu" ];
    hardware = {
        logitech.wireless = {
            enable = true;
            enableGraphical = true;
        };
        graphics = {
            enable = true;
            enable32Bit = true; # Needed for steam
        };
    };

    # Add ntfs support
    boot.supportedFilesystems = [ "ntfs" ];

    boot.loader.grub.efiSupport = true;
}
