{ lib, ... }:
{
    config.settings = lib.mkForce {
        home = {
            apps = {
                autostart.enable = false;
                level = "light";
            };
            scripts = false;
            terminal.terminals.alacritty = true;
            terminal.editors.nvim = true;
        };
        nixos.keyboard.custom_layout = false;
        nixos.steamdeck.enable = true;
        nixos.display_manager = "none";
        nixos = {
            system = {
                bootloader = false;
            };
        };
    };
}
