{
    imports = [
        ../../settings.nix
    ];
    config = {
        settings.values.primary-monitor = "eDP-1";
        settings.modules.nixos.services.battery.enable = true;
    };
}
