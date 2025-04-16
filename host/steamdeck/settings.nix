{ lib, ... }:
{
    config.settings = {
        home = {
            apps = {
                autostart.enable = false;
                level = lib.mkForce "minimal";
            };
            scripts = false;
            terminal.terminals.alacritty = true;
            theme = false;
        };
        nixos.keyboard.custom_layout = false;
        nixos.steamdeck.enable = true;
    };
}
