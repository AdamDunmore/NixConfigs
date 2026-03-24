-- TODO reenabled missing lsps

local capabilities = require('blink.cmp').get_lsp_capabilities();

vim.diagnostic.config({
    signs = true,
    virtual_text = true
})

vim.lsp.config("*", {    
    capabilities = capabilities,
})

vim.lsp.enable("lua_ls")
vim.lsp.enable("nil_ls")
