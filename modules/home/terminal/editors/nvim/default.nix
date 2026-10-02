{ config, inputs, ... }:

let
    cfg = config.settings.modules.home.terminal.editors.nvim;
in
{
    imports = [ inputs.neovim.homeManagerModules.default ];
    config = {
        programs.configuredNeovim = {
            enable = cfg.enable;
            ai = cfg.ai;
            colours = config.settings.values.colours;
            localPath = cfg.localPath;
        };
    };
}
