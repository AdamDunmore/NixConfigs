-- Render markdown
require('render-markdown').setup({
    file_types = { 'markdown' },
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
