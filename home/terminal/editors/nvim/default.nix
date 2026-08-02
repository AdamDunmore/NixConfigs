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
                    nixd
                    typescript-language-server
                    jdt-language-server # Broken?
                    pyright
                    lua-language-server
                    vscode-langservers-extracted
                    bash-language-server
                    clang-tools
                    zls
                    luajitPackages.luarocks 
                    vue-language-server
                    openssl
                    vtsls

                    # Deps
                    rustc
                    cargo
                ];
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
               	initLua = ''
                _G.paths = {
                    vue_language_server =
                    "${pkgs.vue-language-server}/lib/node_modules/@vue/language-server",
                }

                require("main")
                '';
        };
    };
}
