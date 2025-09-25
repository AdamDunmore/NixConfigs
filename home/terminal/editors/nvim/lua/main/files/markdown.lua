-- Render markdown


vim.api.nvim_create_autocmd("BufReadCmd", {
    pattern = "*md.aes",
    callback = function(args)
        vim.bo.filetype = "markdown" 
    end
})

require('render-markdown').setup({
    file_types = { 'markdown', 'aes' },
    render_modes = { 'n', 'c', 't' },
    anti_conceal = {  enabled = false },
    on = {
        attach = function() 
            vim.cmd("setlocal spell spelllang=en_gb");
        end,
    },
    heading = {
        enabled = true,
        sign = false,
    },
    indent = {
        enabled = true,
        skip_heading = true,
    }
})
