require('main.code.treesitter');
require('main.code.snippets');
require('main.code.lsp');
require('main.code.completion');
require('main.code.comment');

if _G.options.enableAi then 
    require('main.code.sidekick');
    require('main.code.minuet');
end
