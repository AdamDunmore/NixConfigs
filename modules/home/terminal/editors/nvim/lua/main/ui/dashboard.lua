--Imports Dashboard
require('dashboard').setup {
	theme = "doom",

    config = {
        header = { 
            "┏━┓━┏┓┏━━━┓┏━━━┓┏┓━━┏┓┏━━┓┏━┓┏━┓",
            "┃┃┗┓┃┃┃┏━━┛┃┏━┓┃┃┗┓┏┛┃┗┫┣┛┃┃┗┛┃┃",
            "┃┏┓┗┛┃┃┗━━┓┃┃━┃┃┗┓┃┃┏┛━┃┃━┃┏┓┏┓┃",
            "┃┃┗┓┃┃┃┏━━┛┃┃━┃┃━┃┗┛┃━━┃┃━┃┃┃┃┃┃",
            "┃┃━┃┃┃┃┗━━┓┃┗━┛┃━┗┓┏┛━┏┫┣┓┃┃┃┃┃┃",
            "┗┛━┗━┛┗━━━┛┗━━━┛━━┗┛━━┗━━┛┗┛┗┛┗┛",
            "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━",
            "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━",
        },

        center = {
            {
                icon = '  ',
                icon_hl = 'Title',
                desc = 'Find File           ',
                desc_hl = 'String',
                key = 'f',
                key_hl = 'Number',
                key_format = ' %s', -- remove default surrounding `[]`
                action = 'Telescope find_files'
            },
      
            {
                icon = '  ',
                icon_hl = 'Title',
                desc = 'Search PC for files',
                desc_hl = 'String',
                key = 's',
                key_hl = 'Number',
                key_format = ' %s',
                action = 'ADTelescopeFindFilesRoot'
            },

            {
                icon = ' 󱞂 ',
                icon_hl = 'Title',
                desc = 'Open Empty Buffer',
                desc_hl = 'String',
                key = 'b',
                key_hl = 'Number',
                key_format = ' %s',
                action = 'enew'
            },

            {
                icon = '  ',
                icon_hl = 'Title',
                desc = 'Open Projects',
                desc_hl = 'String',
                key = 'p',
                key_hl = 'Number',
                key_format = ' %s',
                action = 'Telescope project'
            },

            {
                icon = ' 󰅗 ',
                icon_hl = 'Title',
                desc = 'Exit',
                desc_hl = 'String',
                key = 'x',
                key_hl = 'Number',
                key_format = ' %s',
                action = 'exit'
            }
        },
        
        footer = {}
    }
}

