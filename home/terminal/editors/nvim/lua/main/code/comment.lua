require('nvim_comment').setup({
    create_mappings = false 
})

vim.api.nvim_set_keymap(
        'v',
        '<leader>cc',
        ":CommentToggle<CR>",
        {noremap = false, silent = true}
)
