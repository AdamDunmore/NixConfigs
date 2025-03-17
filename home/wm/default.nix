{ config, ...}:

let
  cfg = config.settings.home.wm;
in
{
    imports = [
        ./hyprland.nix
        ./river.nix
        ./sway.nix
    ];

    config = {
        home.sessionVariables = {
            ADAM_WM = cfg.default;
            ADAM_LOCKER = cfg.default_locker;
        };
    };
}
