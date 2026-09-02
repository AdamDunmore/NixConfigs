{ config, lib, pkgs, ... }:
let
    cfg = config.settings.modules.nixos.services.ai;

    inherit (lib) mkIf;
in
{
    config = mkIf cfg.enable {
        services.ollama = {
            enable = true;
            package = if (cfg.enableRocm) then pkgs.ollama-rocm else pkgs.ollama;
            syncModels = true;
            loadModels = [
                "llama3.1"
                "deepseek-r1"
                # "qwen3-coder"
                "qwen2.5-coder:3b"
                "qwen3.8:27b"
                # granite4.1:3b
            ];
            environmentVariables = {
                OLLAMA_CONTEXT_LENGTH = "16384";
                HSA_OVERRIDE_GFX_VERSION = "10.3.0";
            };
        };
    };
}
