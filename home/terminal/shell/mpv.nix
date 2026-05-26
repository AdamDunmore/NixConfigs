{ lib, config, ... }:

let
    cfg = config.settings.home.terminal.shell.mpv;
    cfg_terminal = config.settings.home.terminal.terminals;
    inherit (lib) mkIf;
in
{   
    config = mkIf cfg {
        xdg.desktopEntries.mpv = {
          name = "mpv";
          exec = "mpv -- %U";
          terminal = true;
        };

        programs.mpv = {
            enable = true;    
            config = {
                vo = mkIf (cfg_terminal.ghostty || cfg_terminal.kitty) "kitty";
            };
        };
    };
}
