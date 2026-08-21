{ lib, config, ... }:
let
    inherit (lib) mkOption;
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
    options.settings.modules.home.terminal.shell = {
        enable = mkOption {
            type = lib.types.bool;
            default = config.settings.modules.home.terminal.enable;
            example = false;
            description = "Enables the shell modules";
        };
    };
}
