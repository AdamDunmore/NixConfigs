{ lib, config, pkgs, ... }:
let
    cfg = config.settings.modules.nixos.display_managers;
    greeter = import ./greeter.nix { inherit pkgs; };
    inherit (lib) mkIf;
in
{
    config = mkIf (cfg.default == "greetd") {
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
