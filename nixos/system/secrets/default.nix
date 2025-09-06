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
            openai_key = {
                sopsFile = ./secrets.yaml;
                key = "openai_key";
            };

            ts_key = {
                sopsFile = ./secrets.yaml;
                key = "ts_key";
            };

            lastfm_pass = {
                sopsFile = ./secrets.yaml;
                key = "lastfm_pass";
            };

            subsonic_pass = {
                owner = mkIf config.settings.nixos.services.mopidy.enable "mopidy";
                sopsFile = ./secrets.yaml;
                key = "subsonic_pass";
            }; 

            nextcloud_pass = {
                sopsFile = ./secrets.yaml;
                key = "nextcloud_pass";
                mode = "0444";
            };
        };
        
        sops.templates = {
            "mopidy.conf" = {
                content = ''
                    [subidy]
                    password = ${config.sops.placeholder."subsonic_pass"}
                '';
                owner = mkIf config.settings.nixos.services.mopidy.enable "mopidy";
            };
        };
    };
}
