{ lib, config, pkgs, ... }:

let
  cfg = config.settings.home.terminal.shell.zellij;
  colours = import ../../../values/colours.nix;
in
with lib;
{
    config = mkIf cfg {
        programs.zellij = {
            enable = true;
            settings = {
                default_shell = "${pkgs.zsh}/bin/zsh";
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
