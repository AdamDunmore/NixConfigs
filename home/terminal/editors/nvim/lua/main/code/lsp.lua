local lsp_config = require('lspconfig');
local capabilities = require('cmp_nvim_lsp').default_capabilities();

-- Signatures
require('lsp_signature').setup({
    bind = true,
    hint_enable = true,
    floating_window = true,
    handler_opts = {
        border = "rounded"
    }
});

-- Java
lsp_config.jdtls.setup({
    capabilities = capabilities,
})

-- Lua
lsp_config.lua_ls.setup({
    capabilities = capabilities,
})

-- Python
lsp_config.pyright.setup({
    capabilities = capabilities,
})

-- Java/Typescript 
lsp_config.ts_ls.setup({
    capabilities = capabilities,
})

-- Nix
lsp_config.nil_ls.setup({
    capabilities = capabilities,
})

-- Rust
lsp_config.rust_analyzer.setup({
    capabilities = capabilities,
})

-- HTML
lsp_config.html.setup({
    capabilities = capabilities,
})

--CSS
lsp_config.cssls.setup({
    capabilities = capabilities,
})

-- Bash
lsp_config.bashls.setup({
    capabilities = capabilities,
})

-- C/C++
lsp_config.clangd.setup({
    capabilities = capabilities,
})

-- Zig
lsp_config.zls.setup({
    capabilities = capabilities,
})

-- Vue
lsp_config.volar.setup({
    capabilities = capabilities,
})

-- Dart
lsp_config.dartls.setup({
    capabilities = capabilities,
})
