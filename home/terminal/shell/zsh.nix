{ pkgs, lib, config, ... }:

let
    cfg = config.settings.home.terminal.shell.zsh;
    cfg_editors = config.settings.home.editors;
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
        envExtra = "
            HOSTNAME=$(hostname)" 
            + ( mkIf cfg_editors.nvim "MANPAGER='nvim +Man!'" )
        ;
        shellAliases = {
            top = "htop";

            ls = "${lsd} -l";
            lst = "${lsd} --tree -l";

            cds = "echo \"Disk usage of current dir: $(du . -sh)\"";

            ze = "zellij options --attach-to-session=true --session-name=main"; 
    
            nix-switch = "sudo nixos-rebuild switch --flake";
            nix-test = "sudo nixos-rebuild test --fast --flake";

            emacs = mkIf cfg_editors.emacs "emacs -nw --init-directory ~/.config/emacs";
        };
    };
  }; 
}
