local Popup = require("nui.popup")
local event = require("nui.utils.autocmd").event

-- File Explorer Help
local file_explorer_help_text = {
    "Normal",
    "c - Create file",
    "d - Delete file",
    "m - Move selected files",
    "y - Yank and paste selected files",
    "f - Toggle between file on folder mode",
    "Tab - Select"
}

local file_explorer_help = Popup({
    border = {
        style = "rounded",
        text = {
            top = "Help"
        }
    },
    focusable = false,
    position = "20%",
    size = {
        height = "20%",
        width = "45%",
    },
    zindex = 100
})

vim.api.nvim_buf_set_lines(file_explorer_help.bufnr, 0, 1, false, file_explorer_help_text);

local file_explorer_help_mounted = false


local function file_explorer_help_toggle()
    if not file_explorer_help_mounted then file_explorer_help:mount(); file_explorer_help_mounted = true;
    else file_explorer_help:show()
    end
end

vim.api.nvim_create_user_command("ADNUIFileExplorerHelp", file_explorer_help_toggle, {});
vim.api.nvim_create_user_command("ADNUIFileExplorerHelpHide", function() file_explorer_help:hide() end, {});


