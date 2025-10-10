{ lib, config, pkgs, ... }:
let
    cfg = config.settings.nixos.display_manager;
    greeter = import ./greeter.nix { inherit pkgs; };
    inherit (lib) mkIf;
in
{
  config = mkIf (cfg == "greetd") {
    services.greetd = {
        enable = true;
        settings = {
            default_session = {
              command = "${pkgs.cage}/bin/cage -s -- ags run -d ${pkgs.writeText "greetd-ags-js" "${greeter.greeter}"}";
            };
        };
    };
  };
}
