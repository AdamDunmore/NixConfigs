{ pkgs, lib, config, primary-user, ... }:
let
    cfg = config.settings.nixos.system.enable;
    inherit (lib) mkIf;
in
{
    config = mkIf cfg {
        users.users.${primary-user} = {
            group = "users";
            createHome = true;
            isNormalUser = true;
            description = "";
            extraGroups = [ "networkmanager" "wheel" "audio" "dialout" "vboxusers" ];
            shell = mkIf config.settings.home.terminal.shell.zsh pkgs.zsh;
            ignoreShellProgramCheck = true;
        };
    };
}
