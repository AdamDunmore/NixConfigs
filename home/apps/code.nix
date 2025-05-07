{ pkgs, lib, config, ... }:
let
    cfg = config.settings.home.apps.level;
    inherit (lib) mkIf;
in
{
    config = mkIf (cfg == "light" || cfg == "all") {
        programs.vscode = {
            enable = true;
            profiles.default = {
                extensions = with pkgs.vscode-extensions; [
                    vscodevim.vim
                    vue.volar
                    golang.go
                    jnoortheen.nix-ide
                    ms-python.python
                    ritwickdey.liveserver
                    ms-vsliveshare.vsliveshare
                ];
                enableUpdateCheck = false;
                userSettings = {
                    "files.autoSave" = "off";
                };
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
            };
            mutableExtensionsDir = false;
        };
    };
}
