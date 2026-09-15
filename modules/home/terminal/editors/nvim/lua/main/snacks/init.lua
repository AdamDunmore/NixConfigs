local dashboard = require('main.snacks.dashboard');
local dim = require('main.snacks.dim')
local indent = require('main.snacks.indent')
local input = require('main.snacks.input')
local notifier = require('main.snacks.notifier')
local picker = require('main.snacks.picker');
local terminal = require('main.snacks.terminal');

require("snacks").setup({
    dashboard = dashboard,
    dim = dim,
    indent = indent,
    input = input,
    notifier = notifier,
    picker = picker,
    terminal = terminal,
})
