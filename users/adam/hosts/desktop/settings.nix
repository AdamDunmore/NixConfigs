{
    imports = [
        ../../settings.nix
    ];
    config = {
        settings.values.primary-monitor = "DP-2";
        settings.modules.home.wm.replays = true;
        settings.modules.nixos.services.ai.enable = true;
    };
}
