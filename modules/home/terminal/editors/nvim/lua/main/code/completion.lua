local ls = require('luasnip');
local cmp = require('blink.cmp');

local sources = {
    'snippets',
    'buffer',
    'lsp',
    'path'
}

if _G.nvim_options.enableAi then
    table.insert(sources, 'minuet')
end

cmp.setup({
    completion = {
        trigger = {
            show_on_keyword = true,
            prefetch_on_insert = false
        },

        menu = {
            auto_show = true
        }
    },
    cmdline = {
        keymap = {
            ['<Up>'] = { 'select_prev', 'fallback' },
            ['<Down>'] = { 'select_next', 'fallback' },
            ['<Tab>'] = { 'accept', 'fallback' }
        },
        completion = {
            menu = {
                auto_show = true
            }
        }
    },
    keymap = {
        ['<Tab>'] = { 'accept', 'fallback' },
    },
    snippets = { preset = "luasnip" },
    sources = {
        default = sources,
        providers = {
            minuet = {
                name = "minuet",
                module = "minuet.blink",
                async = true,
                timeout_ms = 3000,
                score_offset = 100,
            },
        },
    },
    signature = { enabled = true }, 
})
