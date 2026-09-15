-- Keybinds
vim.keymap.set('n', '<leader>ff', function()
    Snacks.picker.smart()
end, { noremap = true, silent = true })

vim.keymap.set('n', '<leader>fg', function()
    Snacks.picker.grep()
end, { noremap = true, silent = true })

vim.keymap.set('n', '<leader>fb', function()
    Snacks.picker.buffers()
end, { noremap = true, silent = true })

vim.keymap.set('n', '<leader>fe', function()
    Snacks.picker.explorer()
end, { noremap = true, silent = true })

vim.keymap.set('n', '<leader>fd', function()
    Snacks.picker.diagnostics()
end, { noremap = true, silent = true })

vim.keymap.set('n', '<leader>fi', function()
    Snacks.picker.lsp_references()
end, { noremap = true, silent = true })

vim.keymap.set('n', '<leader>fp', function()
    Snacks.picker.projects()
end, { noremap = true, silent = true })

return {
    enabled = true,
    layout = {
        preset = "default",
    },
}
