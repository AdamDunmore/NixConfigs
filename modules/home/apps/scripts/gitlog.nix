{ pkgs, lib, config, ... }:
let
    cfg = config.settings.modules.home.apps.scripts;
    gl = pkgs.writeShellScriptBin "gl" ''
        wl-copy "$(git log -n "$1" | grep "commit" | cut -d " " -f 2 | sed -n "$1 p")"
    '';
    inherit (lib) mkIf;
in
{
    config = mkIf cfg.enable {
        home.packages = [ gl ];
    };
}
