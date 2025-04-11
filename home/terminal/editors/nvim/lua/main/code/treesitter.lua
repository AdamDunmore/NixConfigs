-- Todo
-- Setup folding
-- Setup Incremental selection

require('nvim-treesitter.configs').setup({
    highlight = {
        enable = true,
        disable = { "zig" },
    },
    indent = {
        enable = true
    },
});

-- Folding
--
-- vim.opt.foldmethod = 'expr';
-- vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()';
-- vim.opt.foldnestmax = 3;
-- vim.opt.foldlevelstart = 1;

