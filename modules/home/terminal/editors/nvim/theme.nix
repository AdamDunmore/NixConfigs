{ pkgs, colours }:

pkgs.writeTextFile {
    name = "gtk-theme.lua";

    text = ''
        local colours = {
            bg = "${colours.bg}",
            fg = "${colours.fg}",
            bg_selected = "${colours.bg_selected}",
            fg_selected = "${colours.fg_selected}",
            base = "${colours.base}",
            border = "${colours.border}",
        }

        vim.opt.termguicolors = true

        vim.cmd("highlight clear")
        vim.g.colors_name = "gtk-generated"

        local set = vim.api.nvim_set_hl

        set(0, "Normal", {
            fg = colours.fg,
            bg = colours.bg,
        })

        set(0, "NormalFloat", {
            fg = colours.fg,
            bg = colours.base,
        })

        set(0, "FloatBorder", {
            fg = colours.border,
            bg = colours.base,
        })

        set(0, "CursorLine", {
            bg = colours.bg_selected,
        })

        set(0, "CursorLineNr", {
            fg = colours.fg_selected,
        })

        set(0, "Visual", {
            fg = colours.fg_selected,
            bg = colours.bg_selected,
        })

        set(0, "StatusLine", {
            fg = colours.fg,
            bg = colours.base,
        })

        set(0, "StatusLineNC", {
            fg = colours.border,
            bg = colours.base,
        })

        set(0, "WinSeparator", {
            fg = colours.border,
            bg = colours.bg,
        })

        set(0, "LineNr", {
            fg = colours.border,
        })

        set(0, "SignColumn", {
            fg = colours.fg,
            bg = colours.bg,
        })

        set(0, "Pmenu", {
            fg = colours.fg,
            bg = colours.base,
        })

        set(0, "PmenuSel", {
            fg = colours.fg_selected,
            bg = colours.bg_selected,
        })
    '';
}
