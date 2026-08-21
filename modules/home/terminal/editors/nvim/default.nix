{ lib, config, pkgs, inputs, ... }:

let
    cfg = config.settings.modules.home.terminal.editors.nvim;
    inherit (lib) mkIf;
in
{
    imports = [ inputs.mnw.homeManagerModules.mnw ];
    config = mkIf cfg.enable { 
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
                    openssl

                    (pkgs.vue-language-server.overrideAttrs (old: {
                        postInstall = (old.postInstall or "") + ''
                            ln -s ${pkgs.vue-language-server}/lib/language-tools/node_modules/.pnpm/typescript@6.0.3/node_modules/typescript \
                              $out/lib/language-tools/packages/typescript-plugin/node_modules/typescript
                        '';
                    }))
                    vtsls

                    # Deps
                    rustc
                    cargo
                    openssl
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
                        sidekick-nvim
                        minuet-ai-nvim

                        # Notes
                        render-markdown-nvim
                        vim-gnupg
                    ];
                };
               	initLua = ''
                _G.paths = {
                    vue_language_server =
                        "${pkgs.vue-language-server}/lib/language-tools/packages/typescript-plugin";
                }

                require("main")
                '';
        };
    };
}
