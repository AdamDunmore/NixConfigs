{ lib, config, ... }:

let
    cfg = config.settings.modules.home.terminal.emulators.ghostty;
    inherit (lib) mkIf;
in
{
    config = mkIf cfg.enable {
        programs.ghostty = {
            enable = true;
            enableZshIntegration = config.settings.modules.home.terminal.shell.zsh.enable;
            clearDefaultKeybinds = true;
            systemd.enable = true;
            settings = {
                font-family = "IntoneMono NF"; 
                theme = "Nord"; # TODO add to option
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
    };  
}
