-- Keybinds
vim.keymap.set('n', '<leader>tt', function()
    Snacks.terminal.toggle()
end, { noremap = true, silent = true })

return {
    enable = true,
}
