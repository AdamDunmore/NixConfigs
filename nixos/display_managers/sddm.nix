{ pkgs, lib, config, ... }:

let
  cfg = config.settings.nixos.display_manager;
in
{
  config = lib.mkIf (cfg == "sddm") {
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      settings = {};
      # theme = "${pkgs.sddm-astronaut}/share/sddm/themes/sddm-astronaut-theme";
    };
  };
}
