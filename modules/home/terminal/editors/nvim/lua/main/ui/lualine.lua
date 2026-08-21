require('lualine').setup({
    options = {
        icons_enabled = true,
        theme = 'nord',
        section_separators = { left = ' ', right = ' '},
        component_separators = { left = '', right = ' '},
    },

    sections = {
        lualine_a = { "filename" },
        lualine_b = { "filetype" },
        lualine_c = { "encoding", "filesize" },
        lualine_x = { "searchcount" },
        lualine_y = { "location" },
        lualine_z = { "mode" },
    },
});
