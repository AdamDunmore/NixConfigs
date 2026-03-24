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
vim.lsp.enable("nil_ls")
vim.lsp.enable("pyright")
vim.lsp.enable("ts_ls")
vim.lsp.enable("volar")
vim.lsp.enable("zls")
