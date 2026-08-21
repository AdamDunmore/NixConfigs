{ lib, config, pkgs, ... }:

let
  # cfg = config.settings.home.terminal.shell.opencode;
  cfg = true;
  model_small = "qwen2.5-coder:7b";
  model_large = "qwen3-coder:latest";
  inherit (lib) mkIf;
in
{
    config = mkIf cfg {
        programs.opencode = {
            enable = true;
            settings = {
                model = "ollama/${model_small}";

                provider.ollama = {
                    npm = "@ai-sdk/openai-compatible";
                    name = "Ollama";
                    options = {
                        baseURL = "http://127.0.0.1:11434/v1";
                    };

                    models = {
                        "${model_small}" = {
                            name = model_small;
                            tools = true;
                        };

                        "${model_large}" = {
                            name = model_large;
                            tools = true;
                        };
                    };
                };
            };

            extraPackages = with pkgs; [
                git
                ripgrep
                fd
                jq
            ];
        };
    };  
}
