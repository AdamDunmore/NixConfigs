{ lib, config, pkgs, ... }:

let
    cfg = config.adam.terminal.editors.nvim;
in
{
    config = lib.mkIf true {
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
                ];
               	initLua = ''require("main")'';
                plugins = [ ./nvim ] ++ (with pkgs.vimPlugins; [
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

                    # Code #
                    nvim-treesitter.withAllGrammars
                    nvim-cmp
                    luasnip
                    cmp_luasnip
                    nvim-lspconfig
                    cmp-nvim-lsp
                    lsp_signature-nvim
                    nvim-comment

                    # Notes
                    render-markdown-nvim
                ]);
        };
    };
}
