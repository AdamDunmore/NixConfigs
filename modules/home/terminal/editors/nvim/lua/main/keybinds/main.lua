local ls = require("luasnip");

-- Navigation --
-- Windows
vim.api.nvim_set_keymap(
    'n',
    '<leader>wv',
    ":vsplit<CR>",
    { noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
    'n',
    '<leader>wh',
    ":split<CR>",
    { noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
    'n',
    '<leader>wx',
    ":q<CR>",
    { noremap = true, silent = true }
)

vim.api.nvim_set_keymap( --Left
    'n',
    '<A-Left>',
    ":wincmd h<CR>",
    { noremap = true, silent = true }
)

vim.api.nvim_set_keymap( --Up
    'n',
    '<A-Up>',
    ":wincmd k<CR>",
    { noremap = true, silent = true }
)

vim.api.nvim_set_keymap( --Right
    'n',
    '<A-Right>',
    ":wincmd l<CR>",
    { noremap = true, silent = true }
)

vim.api.nvim_set_keymap( --Down
    'n',
    '<A-Down>',
    ":wincmd j<CR>",
    { noremap = true, silent = true }
)

vim.api.nvim_set_keymap( --Left
    'n',
    '<A-S-Left>',
    ":vertical resize -10<CR>",
    { noremap = true, silent = true }
)

vim.api.nvim_set_keymap( --Up
    'n',
    '<A-S-Up>',
    ":horizontal resize -10<CR>",
    { noremap = true, silent = true }
)

vim.api.nvim_set_keymap( --Right
    'n',
    '<A-S-Right>',
    ":vertical resize +10<CR>",
    { noremap = true, silent = true }
)

vim.api.nvim_set_keymap( --Down
    'n',
    '<A-S-Down>',
    ":horizontal resize +10<CR>",
    { noremap = true, silent = true }
)

-- Code --
-- Luasnip
vim.api.nvim_set_keymap(
    'i',
    '<C-k>',
    '<Esc>:ADLuasnipJumpF<CR>',
    { noremap = false, silent = true }
)

vim.api.nvim_set_keymap(
    'i',
    '<C-j>',
    '<Esc>:ADLuasnipJumpB<CR>',
    { noremap = false, silent = true }
)

-- Folding
-- vim.api.nvim_set_keymap(
--     'i',
--     '<leader>zc',
--     '<Esc>',
--     { noremap = false, silent = true }
-- )
