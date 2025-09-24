{ config, lib, pkgs, ... }:
let
    cfg = config.settings.nixos.system.enable;
    inherit (lib) mkIf;
in
{
    config = mkIf cfg {
        programs.gnupg.agent = {
            enable = true;
            pinentryPackage = pkgs.pinentry-curses;
            enableSSHSupport = true;
        };
    };
}
