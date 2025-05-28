vim.opt.cmdheight = 0;

require('noice').setup({
   lsp = {
        progress = { enable = false },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = false,
          ["vim.lsp.util.stylize_markdown"] = false,
          ["cmp.entry.get_documentation"] = false,
        },
    }
});
