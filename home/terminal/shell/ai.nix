{ config, lib, pkgs, ... }:
let
    inherit (lib) mkIf;
    cfg = config.settings.home.terminal.shell.ai;
in
{
    config = mkIf cfg {
        home.packages = [ pkgs.heygpt ];
        # home.sessionVariables.OPENAI_API_KEY = { #TODO move sops to hm instead of nixos
        #     file = config.sops.secrets.openai_key.path;
        # };
    }; 
}
