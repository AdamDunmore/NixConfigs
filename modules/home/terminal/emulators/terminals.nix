{ lib, config, pkgs, colours, font, ... }:

let
    cfg = config.settings.home.terminal.terminals;
    cfg_zsh = config.settings.home.terminal.shell.zsh;
    inherit (lib) mkIf mkMerge;
in
{
  config = mkMerge [
    ( mkIf cfg.alacritty { 
        programs.alacritty = {
            enable = true;
            package = pkgs.alacritty;
            settings = {
                terminal.shell = mkIf cfg_zsh "${pkgs.zsh}/bin/zsh";
                colors = {
                    primary = {
                        background = "${colours.blue.three}";
                        foreground = "${colours.white.one}";
                    };
                };
                keyboard.bindings = [
                        { key = "N"; mods = "Control"; action = "ToggleFullscreen"; }
                        # { key = "E"; mods = "Control"; command = "${pkgs.neovim}/bin/nvim"; }
                ];
            };
        }; 
    } )
    ( mkIf cfg.kitty { 
        programs.kitty = {
            enable = true;
            package = pkgs.kitty;
            font = {
                name = font.name;
                size = 12;
            };

            extraConfig = "
                background #222244
                ${(mkIf config.settings.home.terminal.shell.zsh "shell zsh")}
                confirm_os_window_close 0
            ";
        };
    } )

    ( mkIf cfg.ghostty {
        programs.ghostty = {
            enable = true;
            enableZshIntegration = mkIf cfg_zsh true;
            clearDefaultKeybinds = true;
            systemd.enable = true;
            settings = {
                font-family = "IntoneMono NF"; 
                theme = "Nord";
                notify-on-command-finish = "unfocused";
                notify-on-command-finish-action = "bell,notify";
                scrollbar = "never";
                window-inherit-working-directory = true;
                tab-inherit-working-directory = true;
                split-inherit-working-directory = true;
                window-save-state = "always";
                window-new-tab-position = "end";
                focus-follows-mouse = true;
                shell-integration = "detect";
                shell-integration-features = true;
                quick-terminal-size = "20%, 70%";
                gtk-quick-terminal-layer = "overlay";
                
                keybind = [
                    "ctrl+f=start_search"
                    "ctrl+s=toggle_quick_terminal"

                    "ctrl+shift+c=copy_to_clipboard"
                    "ctrl+shift+v=paste_from_clipboard"

                    "ctrl+t=new_tab"
                    "ctrl+x=close_tab"
                    "ctrl+left=previous_tab"
                    "ctrl+right=next_tab"
                ];
            };
        };
    })
  ];   
}
