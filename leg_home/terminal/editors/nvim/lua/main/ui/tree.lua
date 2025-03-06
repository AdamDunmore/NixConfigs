require("nvim-tree").setup({
    hijack_cursor = true,
    auto_reload_on_write = true,
    sort = {
        sorter = "name",
        folders_first = true
    },
    view = {
        width = 30,
    },
    filters = {
        dotfiles = true,
    },
});

-- Autoclose tree
vim.api.nvim_create_autocmd("BufEnter", {
  nested = true,
  callback = function()
    if #vim.api.nvim_list_wins() == 1 and require("nvim-tree.utils").is_nvim_tree_buf() then
      vim.cmd "quit"
    end
  end
})
