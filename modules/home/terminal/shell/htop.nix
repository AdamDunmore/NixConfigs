{ lib, config, pkgs, ... }:

let
    cfg = config.settings.modules.home.terminal.shell.htop;
    htopLib = config.lib.htop;
    inherit (lib) mkIf;
in
{
    config = mkIf cfg.enable {
        home.shellAliases.top = "htop";
        programs.htop = {
            enable = true;
            package = pkgs.htop-vim ;
            settings = {
                color_scheme = 7; # Nord (could maybe do this programatically?)
                show_cpu_temperature = 1; 
                hide_userland_threads = 1;
                fields = with htopLib.fields; [
                    PID
                    USER
                    PERCENT_CPU
                    PERCENT_MEM
                    TIME
                    COMM
                ];
            };
        };
    };  
}

