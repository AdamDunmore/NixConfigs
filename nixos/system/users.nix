{ local, pkgs, lib, config, ... }:
let
    cfg = config.settings.nixos.system.enable;
in
{
    config = lib.mkIf cfg {
        users.users.${local.username} = {
            isNormalUser = true;
            description = "";
            extraGroups = [ "networkmanager" "wheel" "audio" "dialout" "vboxusers" ];
            shell = pkgs.zsh;
            ignoreShellProgramCheck = true;
        };
    };
}
