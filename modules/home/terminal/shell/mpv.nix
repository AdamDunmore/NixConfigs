{ lib, config, ... }:

let
    cfg = config.settings.modules.home.terminal.shell.mpv;
    defaults = config.settings.modules.home.wm.defaults;
    cfg_emulators = config.settings.modules.home.terminal.emulators;
    inherit (lib) mkIf;
in
{   
    config = mkIf cfg.enable {
        xdg.desktopEntries.mpv = mkIf (cfg_emulators.ghostty.enable || cfg_emulators.kitty.enable) {
          name = "mpv";
          exec = "${defaults.terminal}/bin/${defaults.terminal.meta.mainProgram} -e mpv %U";
          terminal = false;
          type = "Application";
        };

        programs.mpv = {
            enable = true;    
            config = {
                vo = mkIf (cfg_emulators.ghostty.enable || cfg_emulators.kitty.enable) "kitty";
            };
        };
    };
}
