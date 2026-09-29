local capabilities = require("blink.cmp").get_lsp_capabilities();

vim.diagnostic.config({
    signs = true,
    virtual_text = true
})

local vue_plugin = {
    name = "@vue/typescript-plugin",
    location = _G.paths.vue_language_server,
    languages = { "vue" },
    configNamespace = "typescript",
}

vim.lsp.config("ts_ls", {
    filetypes = {
        "typescript",
        "javascript",
        "javascriptreact",
        "typescriptreact",
    },
})

vim.lsp.config("vtsls", {
    settings = {
        vtsls = {
            tsserver = {
                globalPlugins = {
                    vue_plugin,
                },
            },
        },
    },
    filetypes = { "typescript", 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
})

vim.lsp.config("ltex_plus", {
    filetypes = { "asciidoc", "bib", "context", "gitcommit", "html", "markdown", "org", "pandoc", "plaintex", "quarto", "mail", "rmd", "rnoweb", "rst", "tex", "text", "typst", "xhtml" },
    settings = {
        ltex = {
            enabled = { "markdown" },
            language = "en-GB",
            -- filetypes = { "markdown" },
        },
    },
})

vim.lsp.config("lua_ls", {
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
        path ~= vim.fn.stdpath("config")
        and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
      then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you"re using (most
        -- likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
        -- Tell the language server how to find Lua modules same way as Neovim
        -- (see `:h lua-module-load`)
        path = {
          "lua/?.lua",
          "lua/?/init.lua",
        },
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          -- For LSP Settings Type Annotations: https://github.com/neovim/nvim-lspconfig#lsp-settings-type-annotations
          vim.api.nvim_get_runtime_file("lua/lspconfig", false)[1],
        },
        -- Or pull in all of "runtimepath".
        -- NOTE: this is a lot slower and will cause issues when working on
        -- your own configuration.
        -- See https://github.com/neovim/nvim-lspconfig/issues/3189
        -- library = vim.api.nvim_get_runtime_file("", true),
      },
    })
  end,
  settings = {
    Lua = {},
  },
})

vim.lsp.config("*", {    
    capabilities = capabilities,
})

vim.lsp.enable("bashls")
vim.lsp.enable("clangd")
vim.lsp.enable("lua_ls")
vim.lsp.enable("jdtls")
vim.lsp.enable("rust_analyzer")
vim.lsp.enable("nixd")
vim.lsp.enable("pyright")
vim.lsp.enable("ts_ls")
vim.lsp.enable("zls")
vim.lsp.enable("cssls")
vim.lsp.enable("html")
vim.lsp.enable({"vtsls", "vue_ls"})
vim.lsp.enable("gopls")
vim.lsp.enable("ltex_plus")
