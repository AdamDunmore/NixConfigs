{ lib, config, pkgs, ... }:

let
    cfg = config.settings.home.terminal.shell.zellij;
    inherit (lib) mkIf;
in
{
    config = mkIf cfg {
        programs.zellij = {
            enable = true;
            settings = {
                default_shell = mkIf config.settings.home.terminal.shell.zsh "${pkgs.zsh}/bin/zsh";
                default_mode = "Locked";
                pane_frames = false;
                theme = "nord";
            };
        };
        xdg.configFile."zellij/config.kdl".text = ''
            keybinds clear-defaults=true{
                shared {
                    bind "Alt r" { SwitchToMode "Normal"; }
                    bind "Alt l" { SwitchToMode "Locked"; }
                }

                normal {
                    bind "n" { NewPane "Right"; }
                    bind "x" { CloseFocus; }
                    bind "f" { ToggleFocusFullscreen; }
                    bind "e" { Quit; }
                }

                locked {
                }
            }
        '';
    };
}
