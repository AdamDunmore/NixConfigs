{ lib, config, user, pkgs, ... }:
let
    cfg = config.settings.modules.nixos.base.users;
    inherit (lib) mkIf;
in
{
    config = mkIf cfg.enable {
        users.users.${user} = {
            group = "users";
            createHome = true;
            isNormalUser = true;
            description = "The devices main user";
            extraGroups = [ "networkmanager" "wheel" "audio" "dialout" "vboxusers" ];
            shell = mkIf config.settings.modules.home.terminal.shell.zsh.enable pkgs.zsh;
            ignoreShellProgramCheck = true;
            hashedPasswordFile = config.sops.secrets.user_password.path;
            initialPassword = mkIf (!config.settings.modules.nixos.base.secrets.user_password) "changeme";
        };
    };
}
