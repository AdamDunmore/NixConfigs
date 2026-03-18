{ config, lib, ... }:
let
    cfg = config.settings.nixos.services.ai;

    inherit (lib) mkIf;
in
{
    config = mkIf cfg {
        services.ollama = {
            enable = true;
            syncModels = true;
            loadModels = [
                "llama3.1"
                "deepseek-r1"
                "qwen3-coder"
            ];
        };
    };
}
