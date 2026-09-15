vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        Snacks.dim.enable()
    end,
})

return {
    enabled = true,
}
