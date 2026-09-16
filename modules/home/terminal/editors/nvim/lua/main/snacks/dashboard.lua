return {
    enabled = true,
    width = 60,
    pane_gap = 4,
    preset = {
        keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "b", desc = "New Buffer", action = ":enew" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
    },


    sections = {
        { section = "header" },
        {
            pane = 2,
            icon = " ",
            title = "Git Status",
            section = "terminal",
            enabled = function()
                return Snacks.git.get_root() ~= nil
            end,
            cmd = "git status --short",
            height = 5,
            padding = 1,
            ttl = 5 * 60,
            indent = 3,
        },
        { section = "keys", gap = 1, padding = 1 },
        { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
        {
            pane = 2,
            icon = " ",
            title = "Git Log",
            section = "terminal",
            enabled = function()
                return Snacks.git.get_root() ~= nil
            end,
            cmd = "git log -n 5 --oneline",
            height = 9,
            padding = 1,
            ttl = 5 * 60,
            indent = 3,
        },
    },

}
