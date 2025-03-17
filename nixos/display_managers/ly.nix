{ config, lib, pkgs, ... }:

let
  cfg = config.settings.nixos.display_manager;
in
with lib;
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
