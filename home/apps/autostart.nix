{ config, lib, pkgs, ... }:

let
    cfg = config.settings.home.apps.autostart;
    packages = map (pkg: pkg + "/bin/${pkg.meta.mainProgram}") cfg.apps; 
    as = pkgs.writeShellScriptBin "autostart" (builtins.concatStringsSep " & " packages);
in
{
    config = lib.mkMerge [
        ( lib.mkIf cfg.enable {
            home.packages = [ as ];
            xdg.desktopEntries.autostart = {
                name = "AS";
                genericName = "Autostart";
                exec = "${as}/bin/autostart";
                terminal = false;
            }; 
        })
        (lib.mkIf cfg.runOnBoot {
            xdg.autostart = {
                enable = true;
                readOnly = true;
                entries = [ as ];
            };
        })
    ];
}
