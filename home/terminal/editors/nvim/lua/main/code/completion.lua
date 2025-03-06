local cmp = require('cmp');
local types = require('cmp.types');
local ls = require('luasnip');

vim.opt.completeopt = { 'menu', 'menuone', 'noselect' };

cmp.setup({
    snippet = {
        expand = function(args)
            ls.lsp_expand(args.body)
        end
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<Tab>'] = cmp.mapping.confirm({ select = true }),
        ['<Esc>'] = cmp.mapping.close(),
        --['<Up>'] = cmp.select_prev_item({ behavior = types.cmp.SelectBehavior.Select }),
        --['<Down>'] = cmp.select_next_item({ behavior = types.cmp.SelectBehavior.Select }),
    }),
    sources = cmp.config.sources({
        { name = 'path' },
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
    })
});
