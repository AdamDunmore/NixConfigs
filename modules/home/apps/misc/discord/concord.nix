{ config, lib, ... }:
let
    cfg = config.settings.modules.home.apps.misc.discord;
    inherit (lib) mkIf;
in
{
    config = mkIf (cfg.enable && cfg.flavour == "concord") {
        programs.concord = {
            enable = true;
            settings = {
                display.circular_avatars = true;
            };
            keymapSettings = {
                guild_actions = {
                    LeaveServer = { keys = [ "l" ]; description = "Leave Server"; };  
                };
            };
            themeSettings = {
                ui.border = {
                    default = "rounded";
                };
            };
        };
    };
}
