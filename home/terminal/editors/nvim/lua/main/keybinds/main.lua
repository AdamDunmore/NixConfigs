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

-- Telescope
vim.api.nvim_set_keymap(
    'n',
    '<leader>fr',
    ":ADTelescopeFindFilesRoot<CR>",
    { noremap = true, silent = true }
);

vim.api.nvim_set_keymap(
    'n',
    '<leader>ff',
    ":Telescope find_files<CR>",
    { noremap = true, silent = true }
);

vim.api.nvim_set_keymap(
    'n',
    '<leader>fd',
    ":Telescope diagnostics<CR>",
    { noremap = true, silent = true }
);

vim.api.nvim_set_keymap(
    'n',
    '<leader>fi',
    ":Telescope lsp_references<CR>",
    { noremap = true, silent = true }
);

vim.api.nvim_set_keymap(
    'n',
    '<leader>fb',
    ":Telescope buffers<CR>",
    { noremap = true, silent = true }
);

vim.api.nvim_set_keymap(
    'n',
    '<leader>fe',
    ":ADNUIFileExplorerHelp<CR>:Telescope file_browser<CR>",
    { noremap = true, silent = true }
);

vim.api.nvim_set_keymap(
    'n',
    '<leader>fp',
    ":Telescope project<CR>",
    { noremap = true, silent = true }
);

-- UI --
-- Nvim Tree
vim.api.nvim_set_keymap(
    'n',
    '<C-t>',
    ":NvimTreeToggle<CR>",
    { noremap = true, silent = true }
)

-- Toggle Term
vim.api.nvim_set_keymap(
    't',
    '<Esc>', 
    [[<C-\><C-n>]], 
    { noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
    'n',
    '<C-\'>',
    ":ToggleTerm<CR>",
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
