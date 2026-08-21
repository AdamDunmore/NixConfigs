-- vim.api.nvim_create_autocmd('FileType', {
--   callback = function(args)
--     local treesitter = require('nvim-treesitter')
--     local lang = vim.treesitter.language.get_lang(args.match)
--     if vim.list_contains(treesitter.get_installed(), lang) then
--       vim.treesitter.start(args.buf)
--     end
--   end,
-- })
--
vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local lang = vim.treesitter.language.get_lang(args.match)
    if lang then
      pcall(vim.treesitter.start, args.buf, lang)
    end
  end,
})

require("nvim-treesitter").setup({
	modules = {},
	sync_install = false,
	ignore_install = {},
	ensure_installed = {},
	auto_install = false,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
})
