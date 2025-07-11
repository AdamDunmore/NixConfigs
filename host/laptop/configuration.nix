{
    networking.hostName = "laptop";
    boot.loader.grub.efiSupport = true;

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
}
