-- Man Page Open
vim.api.nvim_create_autocmd("FileType", { pattern = { "man" }, callback = function() 
     vim.o.laststatus = 0
    vim.opt.relativenumber = false;
end })

-- Cleanup
vim.api.nvim_create_autocmd('BufLeave', { pattern = '*', callback = function()
    vim.o.laststatus = 2
    vim.opt.relativenumber = true;
end })
