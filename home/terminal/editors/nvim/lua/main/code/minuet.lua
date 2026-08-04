require("minuet").setup({
    provider = "openai_fim_compatible",

    provider_options = {
        openai_fim_compatible = {
            end_point = "http://127.0.0.1:11434/v1/completions",
            api_key = "TERM",
            name = "Ollama",
            model = "qwen2.5-coder:7b",

            optional = {
                max_tokens = 256,
                temperature = 0.2,
            },
        },
    },

    virtualtext = {
        auto_trigger_ft = { "*" },
        keymap = {
            accept = '<S-Tab>',
        }
    },

    request_timeout = 3,
    throttle = 1000,

    blink = {
        enable_auto_complete = true,
    },
})
