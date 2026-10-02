{ lib, config, ... }:
let
    inherit (lib) mkOption;
in
{
    options.settings.modules.home.terminal.editors.nvim = {
        enable = mkOption {
            type = lib.types.bool;
            default = config.settings.modules.home.terminal.enable;
            example = false;
            description = "Enables the nvim module";
        };

        ai = mkOption {
            type = lib.types.bool;
            default = false;
            example = true;
            description = "Enables the nvim ai module";
        };

        localPath = mkOption {
            type = lib.types.str;
            default = "~/Projects/NvimConfigs/";
            example = "~/.config/neovim/";
            description = "The path to your neovim config (used for dev mode)";
        };
    };
}
