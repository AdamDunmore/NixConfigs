local telescope = require("telescope");
local telescope_builtin = require("telescope.builtin");
local fb_actions = telescope.extensions.file_browser.actions
local telescope_actions = require("telescope.actions");

local file_ignore_patterns = {
    "node_modules",
    "target",
    "bin",
    
    ".*%.o"
};

-- Setup
--require("telescope").setup({
telescope.setup({
    defaults = {
        file_ignore_patterns = file_ignore_patterns
    },

    extensions = {
        file_browser = {
            hijack_netrw = true,
            mappings = {
                n = {
                    c = fb_actions.create,
                    d = fb_actions.remove,
                    m = fb_actions.move,
                    y = fb_actions.copy,
                    f = fb_actions.toggle_browser,
                    ["<Tab>"] = telescope_actions.toggle_selection,
                    ["<Esc>"] = function(buf) 
                        vim.cmd("ADNUIFileExplorerHelpHide") 
                        telescope_actions.close(buf)
                    end,
                    ["<CR>"] = function(buf) -- Hide help on selection 
                        telescope_actions.select_default(buf)
                        vim.cmd("ADNUIFileExplorerHelpHide") 
                    end,
                },
                i = {
                    ["<Enter>"] = function(buf) -- Hide help on selection 
                        telescope_actions.select_default(buf)
                        vim.cmd("ADNUIFileExplorerHelpHide") 
                    end,
                    ["<Tab>"] = telescope_actions.toggle_selection,
                }
            }
        }
    }
});

telescope.load_extension('project');
telescope.load_extension('file_browser');

-- Commands
local function telescope_find_files_root()
    telescope_builtin.find_files( { cwd = "~/" } );
end
vim.api.nvim_create_user_command("ADTelescopeFindFilesRoot", telescope_find_files_root, {});
