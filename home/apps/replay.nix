
{ config, lib, pkgs, ... }:

let
    cfg = config.settings.home.wm.replays;
    replay = pkgs.writeShellScriptBin "replay" "killall -SIGUSR1 gpu-screen-recorder && notify-send \"Replay Saved\"";

    inherit (lib) mkIf;
in
{
    config = mkIf cfg {
        home.packages = [ replay ];
        xdg.desktopEntries.replay = {
            name = "replay";
            genericName = "Replay";
            exec = "${replay}/bin/replay";
            terminal = false;
        }; 
    };
}
