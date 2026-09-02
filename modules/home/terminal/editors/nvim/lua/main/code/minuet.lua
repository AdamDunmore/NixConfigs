require('minuet').setup {
    provider = 'openai_fim_compatible',
    context_window = 512,
    provider_options = {
        openai_fim_compatible = {
            api_key = 'TERM',
            name = 'Ollama',
            end_point = 'http://127.0.0.1:11434/v1/completions',
            model = 'qwen2.5-coder:3b',
            stream = true,
            optional = {
                max_tokens = 56,
                top_p = 0.9,
            },
        },
    },
    virtualtext = {
        auto_trigger_ft = { "*" },
        keymap = {
            accept = '<S-Tab>',
        }
    },

    request_timeout = 10,
    throttle = 1000,

    blink = {
        enable_auto_complete = true,
    },
}

vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        vim.cmd("Minuet lsp attach")
    end,
})
