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
        ./htop.nix
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
                dcat = "${pkgs.openssl}/bin/openssl enc -d -aes-256-cbc -salt -pbkdf2 -in";
                cds = "echo \"Disk usage of current dir: $(du . -sh)\"";        

                # emacs = mkIf cfg_editors.emacs "emacs -nw --init-directory ~/.config/emacs";
            };
        };
    };
}
