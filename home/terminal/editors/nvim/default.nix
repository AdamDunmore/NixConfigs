{ lib, config, pkgs, inputs, ... }:

let
    cfg = config.settings.home.terminal.editors.nvim;
in
{
    imports = [ inputs.mnw.homeManagerModules.mnw ];
    config = lib.mkIf cfg {
        programs.mnw = {
                enable = true;
                appName = "nv";
                desktopEntry = false;
                extraBinPath = with pkgs; [
                    # Language Servers
                    rust-analyzer
                    nil
                    nodePackages_latest.typescript-language-server
                    jdt-language-server
                    pyright
                    lua-language-server
                    vscode-langservers-extracted
                    bash-language-server
                    clang-tools
                    zls
                    vscode-extensions.vue.volar
                    luajitPackages.luarocks 
                    openssl
                ];
               	initLua = ''require("main")'';
                plugins = {
                    dev.config.pure = ./.;
                    start = with pkgs.vimPlugins; [
                        # Navigation #
                        telescope-nvim
                        telescope-project-nvim
                        telescope-file-browser-nvim

                        # UI #
                        nui-nvim 
                        nord-nvim
                        bufferline-nvim
                        dashboard-nvim
                        nvim-tree-lua
                        noice-nvim
                        toggleterm-nvim
                        lualine-nvim
                        mini-icons

                        # Code #
                        nvim-treesitter.withAllGrammars
                        blink-cmp
                        luasnip
                        nvim-lspconfig
                        nvim-comment

                        # Notes
                        render-markdown-nvim
                        vim-gnupg
                    ];
                };
        };
    };
}
