{ lib, config, inputs, pkgs, ... }:
let
    cfg = config.settings.nixos.system.secrets;
    inherit (lib) mkIf;
in
{
    imports = [ inputs.sops-nix.nixosModules.sops ];
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
            github_ssh_key = {
                path = "/home/adam/.ssh/id_ed25519";
                owner = "adam";
                mode = "0600";
                sopsFile = ./secrets.yaml;
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

            server_pass = {
                sopsFile = ./secrets.yaml;
                key = "server_pass";
                mode = "0444";
            };

            drive_client_id = {
                sopsFile = ./secrets.yaml;
                key = "drive_client_id";
                mode = "0444";
            };

            drive_secret = {
                sopsFile = ./secrets.yaml;
                key = "drive_secret";
                mode = "0444";
            };

            drive_token = {
                sopsFile = ./secrets.yaml;
                key = "drive_token";
                mode = "0444";
            };
            tb_key = {
                sopsFile = ./secrets.yaml;
                key = "tb_key";
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
