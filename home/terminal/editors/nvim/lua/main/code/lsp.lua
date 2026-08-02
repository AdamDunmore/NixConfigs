local capabilities = require('blink.cmp').get_lsp_capabilities();

vim.diagnostic.config({
    signs = true,
    virtual_text = true
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
vim.lsp.enable("vue_ls")
vim.lsp.enable("zls")
vim.lsp.enable("cssls")
vim.lsp.enable("html")
vim.lsp.enable("vtsls")

local vue_plugin = {
    name = "@vue/typescript-plugin",
    location = _G.paths.vue_language_server,
    languages = { "vue" },
    configNamespace = "typescript",
}

vim.lsp.config('vtsls', {
    settings = {
        vtsls = {
            tsserver = {
                globalPlugins = {
                    vue_plugin,
                },
            },
        },
    },
    filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
})

