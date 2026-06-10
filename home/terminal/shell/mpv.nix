{ lib, config, ... }:

let
    cfg = config.settings.home.terminal.shell.mpv;
    cfg_terminal = config.settings.home.terminal.terminals;
    defaults = config.settings.home.wm.defaults;
    inherit (lib) mkIf;
in
{   
    config = mkIf cfg {
        xdg.desktopEntries.mpv = mkIf (cfg_terminal.ghostty || cfg_terminal.kitty) {
          name = "mpv";
          exec = "${defaults.terminal}/bin/${defaults.terminal.meta.mainProgram} -e mpv %U";
          terminal = false;
          type = "Application";
        };

        programs.mpv = {
            enable = true;    
            config = {
                vo = mkIf (cfg_terminal.ghostty || cfg_terminal.kitty) "kitty";
            };
        };
    };
}
