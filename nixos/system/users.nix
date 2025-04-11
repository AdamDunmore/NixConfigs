{ local, pkgs, ... }:

{
    config = {
        users.users.${local.username} = {
            isNormalUser = true;
            description = "";
            extraGroups = [ "networkmanager" "wheel" "audio" "dialout"];
            shell = pkgs.zsh;
            ignoreShellProgramCheck = true;
        };
    };
}
