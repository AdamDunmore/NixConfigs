{ lib, config, inputs, ... }:
let
    cfg = config.settings.modules.nixos.base.secrets;
    inherit (lib) mkIf;
in
{
    imports = [ inputs.sops-nix.nixosModules.sops ];
    config = mkIf cfg.enable {
        sops.defaultSopsFile = ./secrets.yaml;
        sops.secrets = {
            user_password = {
                sopsFile = ./secrets.yaml;
                key = "user_password";
            };

            github_ssh_key = {
                path = "/home/adam/.ssh/id_ed25519";
                owner = "adam";
                mode = "0600";
                sopsFile = ./secrets.yaml;
            };

            ts_key = {
                sopsFile = ./secrets.yaml;
                key = "ts_key";
            };

            lastfm_pass = {
                sopsFile = ./secrets.yaml;
                key = "lastfm_pass";
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
    };
}

