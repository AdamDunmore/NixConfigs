{ pkgs, config, lib, ... }:
let
    cfg = config.settings.home.apps.browser.brave;
    inherit (lib) mkIf;
in
{
    config = mkIf cfg {
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
