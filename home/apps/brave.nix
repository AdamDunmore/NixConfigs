{ pkgs, config, lib, ... }:
let
    cfg = config.settings.home.apps.level;
    inherit (lib) mkIf;
in
{
    config = mkIf (cfg == "light" || cfg == "all") {
        programs.chromium = {
            enable = true;
            package = pkgs.brave;
            commandLineArgs = [
                "--password-store=basic"
                "--disable-features=AIChat,BraveVPN"
            ];
        };    
    };
}
