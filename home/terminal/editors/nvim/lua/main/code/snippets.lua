local ls = require('luasnip');
local i = ls.insert_node;
local s = ls.snippet;
local sn = ls.snippet_node;
local t = ls.text_node;
local fmt = require('luasnip.extras.fmt').fmt;

-- Adds functions for jumping between snippets MAKE ONLY WORK WHEN LS IS OPEN
vim.api.nvim_create_user_command("ADLuasnipJumpF", function() if ls.jumpable(1) then ls.jump(1) end end, {});
vim.api.nvim_create_user_command("ADLuasnipJumpB", function() if ls.jumpable(-1) then ls.jump(-1) end end, {});

-- Add snippets
-- Java
ls.add_snippets("java", {
    s({ -- Fixed Loop
        trig = "for",
        name = "Fixed Loop",
        desc = "Creates a fixed loop"
    }, {  
            t("for(int x = 0; x < "), i(1), t("; x++){"), 
            t({"", "\t"}) ,i(0), 
            t({"","}"}), 
    }),

    s({ -- Conditional Loop
        trig = "while",
        name = "Conditional Loop",
        desc = "Creates a conditional loop"
    }, {  
            t("while("), i(1), t("){"), 
            t({"", "\t"}) ,i(0), 
            t({"","}"}), 
    }),

    s({ -- If
        trig = "if",
        name = "If statement",
        desc = "Creates a if statement"
    }, {  
            t("if("), i(1), t("){"), 
            t({"", "\t"}) ,i(2), 
            t({"","}", ""}), i(0), 
    }),

    s({ -- Elif
        trig = "elif",
        name = "Elif statement",
        desc = "Creates a elif statement"
    }, {  
            t("else if("), i(1), t("){"), 
            t({"", "\t"}) ,i(2), 
            t({"","}", ""}), i(0) 
    }),
})

