{ pkgs, lib, config, ... }:

let
    cfg = config.settings.home.terminal.shell.zsh;
    cfg_editors = config.settings.home.terminal.editors;
    cfg_apps = config.settings.home.apps;
    lsd = "${pkgs.lsd}/bin/lsd";

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
            shellAliases = {
                top = "htop";

                # ls = "${lsd} -l";
                lst = "${lsd} --tree -l";

                cds = "echo \"Disk usage of current dir: $(du . -sh)\"";

                ze = "zellij options --attach-to-session=true --session-name=main"; 

                sync-dir = "${pkgs.rsync}/bin/rsync -Pauv --delete";
        
                nix-switch = "sudo nixos-rebuild switch --flake";
                nix-test = "sudo nixos-rebuild test --fast --flake";

                emacs = mkIf cfg_editors.emacs "emacs -nw --init-directory ~/.config/emacs";
            };
        };
    }; 
}
