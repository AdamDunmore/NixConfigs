-- Todo
-- Setup folding
-- Setup Incremental selection

require('nvim-treesitter.configs').setup({
--    auto_install = true,
--    ensure_installed = {
--        "c",
--        "lua",
--        "java",
--        "python",
--    },
    highlight = {
        enable = true,
        disable = { "zig" },
    },
    indent = {
        enable = true
    },
});
