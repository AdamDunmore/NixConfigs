local ls = require('luasnip');
local cmp = require('blink.cmp');

cmp.setup({
    completion = {
        trigger = {
            show_on_keyword = true
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
        default = { 'snippets', 'buffer', 'lsp', 'path' }
    },
    signature = { enabled = true }, 
})
