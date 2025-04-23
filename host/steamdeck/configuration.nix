{ ... }:

{
  networking.hostName = "steamdeck";
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true; 
  };
}
