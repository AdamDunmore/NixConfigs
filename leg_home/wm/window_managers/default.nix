{ lib, config, pkgs, ...}:

let
  cfg = config.adam.wm.window_managers;
in
with lib;
{
  imports = [
    ./hyprland.nix
    ./river.nix
    ./sway.nix
  ];

  config = mkMerge [
    { home.sessionVariables = {
        ADAM_WM = cfg.default;
        ADAM_LOCKER = cfg.default_locker;
    };}
  ]; 
}
