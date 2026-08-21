{ lib, config, inputs, ... }:
let
    cfg = config.settings.modules.nixos.base.secrets;
    inherit (lib) mkIf;
in
{
    imports = [ inputs.sops-nix.nixosModules.sops ];
    config = mkIf cfg.enable {
        sops = {
            defaultSopsFormat = "yaml";
            age.keyFile = "/etc/age.key";
        };
    };
}
