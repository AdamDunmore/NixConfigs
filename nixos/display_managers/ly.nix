{ config, lib, pkgs, ... }:

let
  cfg = config.settings.nixos.display_manager;
  inherit (lib) mkIf;
in
{
  config = mkIf (cfg == "ly") { 
    services.displayManager.ly = {
      enable = true;
      package = pkgs.ly;
      settings = {
        tty = 1; 
      };
    };
  };
}
