{ lib, config, ... }:
let
    cfg_editors = config.settings.home.terminal.editors;
    inherit (lib) mkIf mkMerge;
in
{
    config = {
        home.sessionVariables = mkMerge [
            { MANPAGER = (mkIf cfg_editors.nvim "nvim +Man!"); } 
        ];
    };

    imports = [
        ./ai.nix
        ./lsd.nix
        ./git.nix
        ./starship.nix
        ./tmux.nix
        ./yazi.nix
        ./zellij.nix
        ./zoxide.nix
        ./zsh.nix
    ];
}
