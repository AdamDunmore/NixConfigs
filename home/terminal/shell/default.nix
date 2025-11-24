{ lib, config, pkgs, ... }:
let
    cfg_editors = config.settings.home.terminal.editors;
    lsd = "${pkgs.lsd}/bin/lsd";
    inherit (lib) mkIf mkMerge;
in
{
    config = {
        home = {    
            sessionVariables = {
                MANPAGER = (mkIf cfg_editors.nvim "nvim +Man!");
                SOPS_AGE_KEY_FILE = "/etc/age.key";
                SSH_ASKPASS = "";
                EDITOR = "nvim";
            };
            shell.enableZshIntegration = config.settings.home.terminal.shell.zsh;
            shellAliases = {
                top = "htop";

                # ls = "${lsd} -l";
                lst = "${lsd} --tree -l";

                cds = "echo \"Disk usage of current dir: $(du . -sh)\"";
                copy-pat = "wl-copy $(sudo cat ~/pat | cut -c1-40)";

                ze = "zellij options --attach-to-session=true --session-name=main"; 

                sync-dir = "${pkgs.rsync}/bin/rsync -Pauv --delete";
        
                nix-switch = "sudo nixos-rebuild switch --flake";
                nix-test = "sudo nixos-rebuild test --fast --flake";

                toggle-night = "pgrep gammastep >/dev/null && pkill gammastep || nohup gammastep -O 17000K -b 0.3 &";

                emacs = mkIf cfg_editors.emacs "emacs -nw --init-directory ~/.config/emacs";
            };
        };
    };

    imports = [
        ./lsd.nix
        ./intellishell.nix
        ./git.nix
        ./starship.nix
        ./tmux.nix
        ./yazi.nix
        ./zellij.nix
        ./zoxide.nix
        ./zsh.nix
    ];
}
