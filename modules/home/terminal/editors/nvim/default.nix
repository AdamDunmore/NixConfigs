{ config, inputs, ... }:

let
    cfg = config.settings.modules.home.terminal.editors.nvim;
in
{
    imports = [ inputs.neovim.homeManagerModules.default ];
    config = {
        programs.configuredNeovim = {
            enable = cfg.enable;
            ai = config.settings.modules.nixos.services.ai.enable;
            colours = config.settings.values.colours;
            localPath = cfg.localPath;
        };
    };
}
