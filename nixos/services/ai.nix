{ config, lib, pkgs, ... }:
let
    cfg = config.settings.nixos.services.ai;

    inherit (lib) mkIf;
in
{
    config = mkIf cfg {
        services.ollama = {
            enable = true;
            package = pkgs.ollama-rocm;
            syncModels = true;
            loadModels = [
                "llama3.1"
                "deepseek-r1"
                "qwen3-coder"
                "qwen2.5-coder:7b"
            ];
            environmentVariables = {
                OLLAMA_CONTEXT_LENGTH = "16384";
                HSA_OVERRIDE_GFX_VERSION = "10.3.0";
            };
        };
    };
}
