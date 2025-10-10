{ local, pkgs, lib, config, ... }:
let
    cfg = config.settings.nixos.system.enable;
    inherit (lib) mkIf;
in
{
    config = mkIf cfg {
        users.users.${local.username} = {
            isNormalUser = true;
            description = "";
            extraGroups = [ "networkmanager" "wheel" "audio" "dialout" "vboxusers" ];
            shell = mkIf config.settings.home.terminal.shell.zsh pkgs.zsh;
            ignoreShellProgramCheck = true;
        };
    };
}
