require('nvim-treesitter.configs').setup({
    highlight = {
        enable = true,
        disable = { "zig" },
    },
    indent = {
        enable = true
    },
});
