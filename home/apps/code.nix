{ pkgs, lib, config, ... }:
let
    cfg = config.settings.home.apps.level;
in
with lib;
{
    config = mkIf (cfg == "light" || cfg == "all") {
        programs.vscode = {
            enable = true;
            enableUpdateCheck = false;
            mutableExtensionsDir = false;
            extensions = with pkgs.vscode-extensions; [
                vscodevim.vim
                vue.volar
                golang.go
                jnoortheen.nix-ide
                ms-python.python
                ritwickdey.liveserver
                ms-vsliveshare.vsliveshare
            ];
            languageSnippets = {
                javascript = {
                    log = {
                        body = [
                            "console.log($0);"
                        ];
                        description = "Inserts console.log()";
                        prefix = [
                            "log"
                        ];
                    };
                };
            };
            userSettings = {
                "files.autoSave" = "off";
            };
        };
    };
}
