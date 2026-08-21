{ pkgs, config, lib, ... }:
let
    cfg = config.settings.modules.home.terminal.shell;
    inherit (lib) mkIf;
in
{
    imports = [
        ./git.nix
        ./intellishell.nix
        ./lsd.nix
        ./mpv.nix
        ./opencode.nix
        ./starship.nix
        ./tmux.nix
        ./yazi.nix
        ./zellij.nix
        ./zoxide.nix
        ./zsh.nix
    ];

    config = mkIf cfg.enable {
        home = {    
            sessionVariables = {
                MANPAGER = (mkIf config.settings.modules.home.terminal.editors.nvim.enable "nvim +Man!");
                SOPS_AGE_KEY_FILE = "/etc/age.key";
                SSH_ASKPASS = "";
                EDITOR = "nvim";
            };
            shell.enableZshIntegration = cfg.zsh.enable;
            shellAliases = {
                x = "xdg-open";
                
                top = "htop";

                # ls = "${pkgs.lsd}/bin/lsd -l";
                lst = "${pkgs.lsd}/bin/lsd --tree -l";
                dcat = "${pkgs.openssl}/bin/openssl enc -d -aes-256-cbc -salt -pbkdf2 -in";

                cds = "echo \"Disk usage of current dir: $(du . -sh)\"";
                gl1 = "wl-copy $(git log -n 1 | grep \"commit\" | cut -d \" \" -f 2)";

                ze = "zellij options --attach-to-session=true --session-name=main"; 

                sync-dir = "${pkgs.rsync}/bin/rsync -Pauv --delete";
        
                nix-switch = "sudo nixos-rebuild switch --flake";
                nix-test = "sudo nixos-rebuild test --fast --flake";

                # emacs = mkIf cfg_editors.emacs "emacs -nw --init-directory ~/.config/emacs";
            };
        };
    };
}
