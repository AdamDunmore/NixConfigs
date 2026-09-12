{ lib, config, pkgs, ... }:

let
    cfg = config.settings.modules.home.terminal.shell.zellij;
    colours = config.settings.values.colours;

    inherit (lib) mkIf;

    hexToRgb = hex:
        let
            h = lib.removePrefix "#" hex;
        in
        lib.concatStringsSep " " [
            (toString (lib.fromHexString (builtins.substring 0 2 h)))
            (toString (lib.fromHexString (builtins.substring 2 2 h)))
            (toString (lib.fromHexString (builtins.substring 4 2 h)))
        ];
in
{
    config = mkIf cfg.enable {
        programs.zellij = {
            enable = true;

            settings = {
                default_shell = mkIf config.settings.modules.home.terminal.shell.zsh.enable "${pkgs.zsh}/bin/zsh";

                default_mode = "Locked";
                pane_frames = false;
                theme = "gtk-generated";
            };

            themes."gtk-generated" = ''
                themes {
                    gtk-generated {
                        text_unselected {
                            base ${hexToRgb colours.fg}
                            background ${hexToRgb colours.bg}
                            emphasis_0 ${hexToRgb colours.fg}
                            emphasis_1 ${hexToRgb colours.fg_selected}
                            emphasis_2 ${hexToRgb colours.border}
                            emphasis_3 ${hexToRgb colours.base}
                        }

                        text_selected {
                            base ${hexToRgb colours.fg_selected}
                            background ${hexToRgb colours.bg_selected}
                            emphasis_0 ${hexToRgb colours.fg}
                            emphasis_1 ${hexToRgb colours.fg_selected}
                            emphasis_2 ${hexToRgb colours.border}
                            emphasis_3 ${hexToRgb colours.base}
                        }

                        ribbon_unselected {
                            base ${hexToRgb colours.fg}
                            background ${hexToRgb colours.bg}
                            emphasis_0 ${hexToRgb colours.fg}
                            emphasis_1 ${hexToRgb colours.fg_selected}
                            emphasis_2 ${hexToRgb colours.border}
                            emphasis_3 ${hexToRgb colours.base}
                        }

                        ribbon_selected {
                            base ${hexToRgb colours.fg_selected}
                            background ${hexToRgb colours.bg_selected}
                            emphasis_0 ${hexToRgb colours.fg}
                            emphasis_1 ${hexToRgb colours.fg_selected}
                            emphasis_2 ${hexToRgb colours.border}
                            emphasis_3 ${hexToRgb colours.base}
                        }

                        table_title {
                            base ${hexToRgb colours.fg}
                            background ${hexToRgb colours.bg}
                            emphasis_0 ${hexToRgb colours.fg}
                            emphasis_1 ${hexToRgb colours.fg_selected}
                            emphasis_2 ${hexToRgb colours.border}
                            emphasis_3 ${hexToRgb colours.base}
                        }

                        table_cell_unselected {
                            base ${hexToRgb colours.fg}
                            background ${hexToRgb colours.bg}
                            emphasis_0 ${hexToRgb colours.fg}
                            emphasis_1 ${hexToRgb colours.fg_selected}
                            emphasis_2 ${hexToRgb colours.border}
                            emphasis_3 ${hexToRgb colours.base}
                        }

                        table_cell_selected {
                            base ${hexToRgb colours.fg_selected}
                            background ${hexToRgb colours.bg_selected}
                            emphasis_0 ${hexToRgb colours.fg}
                            emphasis_1 ${hexToRgb colours.fg_selected}
                            emphasis_2 ${hexToRgb colours.border}
                            emphasis_3 ${hexToRgb colours.base}
                        }

                        list_unselected {
                            base ${hexToRgb colours.fg}
                            background ${hexToRgb colours.bg}
                            emphasis_0 ${hexToRgb colours.fg}
                            emphasis_1 ${hexToRgb colours.fg_selected}
                            emphasis_2 ${hexToRgb colours.border}
                            emphasis_3 ${hexToRgb colours.base}
                        }

                        list_selected {
                            base ${hexToRgb colours.fg_selected}
                            background ${hexToRgb colours.bg_selected}
                            emphasis_0 ${hexToRgb colours.fg}
                            emphasis_1 ${hexToRgb colours.fg_selected}
                            emphasis_2 ${hexToRgb colours.border}
                            emphasis_3 ${hexToRgb colours.base}
                        }

                        frame_unselected {
                            base ${hexToRgb colours.border}
                            background ${hexToRgb colours.bg}
                            emphasis_0 ${hexToRgb colours.fg}
                            emphasis_1 ${hexToRgb colours.fg_selected}
                            emphasis_2 ${hexToRgb colours.border}
                            emphasis_3 ${hexToRgb colours.base}
                        }

                        frame_selected {
                            base ${hexToRgb colours.border}
                            background ${hexToRgb colours.bg}
                            emphasis_0 ${hexToRgb colours.fg}
                            emphasis_1 ${hexToRgb colours.fg_selected}
                            emphasis_2 ${hexToRgb colours.border}
                            emphasis_3 ${hexToRgb colours.base}
                        }

                        frame_highlight {
                            base ${hexToRgb colours.fg_selected}
                            background ${hexToRgb colours.bg_selected}
                            emphasis_0 ${hexToRgb colours.fg}
                            emphasis_1 ${hexToRgb colours.fg_selected}
                            emphasis_2 ${hexToRgb colours.border}
                            emphasis_3 ${hexToRgb colours.base}
                        }

                        exit_code_success {
                            base ${hexToRgb colours.fg}
                            background ${hexToRgb colours.bg}
                            emphasis_0 ${hexToRgb colours.fg}
                            emphasis_1 ${hexToRgb colours.fg_selected}
                            emphasis_2 ${hexToRgb colours.border}
                            emphasis_3 ${hexToRgb colours.base}
                        }

                        exit_code_error {
                            base ${hexToRgb colours.fg}
                            background ${hexToRgb colours.bg}
                            emphasis_0 ${hexToRgb colours.fg}
                            emphasis_1 ${hexToRgb colours.fg_selected}
                            emphasis_2 ${hexToRgb colours.border}
                            emphasis_3 ${hexToRgb colours.base}
                        }
                    }
                }
            '';
        };

        xdg.configFile."zellij/config.kdl".text = ''
            keybinds clear-defaults=true {
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
