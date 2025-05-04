{ lib, config, inputs, pkgs, ... }:
let
    cfg = config.settings.nixos.system.secrets;
    inherit (lib) mkIf;
in
{
    imports = [ inputs.sops-nix.nixosModules.sops ];
    # secrets.yaml
    # Encrypt
    # Save password at /etc/sops-password
    config = mkIf cfg {
        sops = {
            defaultSopsFile = ./secrets.yaml;
            defaultSopsFormat = "yaml";
            age.keyFile = "/etc/age.key";
        };

        sops.secrets = {
            github_pat = {
                path = "/home/adam/pat";
                sopsFile = ./secrets.yaml;
                key = "github_pat";
            };
        };
    };
}
