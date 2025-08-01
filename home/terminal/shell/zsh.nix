{ pkgs, lib, config, ... }:

let
    cfg = config.settings.home.terminal.shell.zsh;

    inherit (lib) mkIf;
in
{
    config = mkIf cfg {
        programs.zsh = {
            enable = true;
            package = pkgs.zsh;
            autosuggestion.enable = true;
            syntaxHighlighting.enable = true;
            enableCompletion = true;
            envExtra = "HOSTNAME=$(hostname)";
        };
    }; 
}
