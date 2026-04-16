{ inputs, pkgs, config, lib, ... }:
let
    cfg = config.settings.home.widgets.ags;
    inherit (lib) mkIf;
in
{
    imports = [ inputs.ags.homeManagerModules.default ];

    config = mkIf cfg {
        home.packages = with pkgs; [ 
            gammastep 
            mpdris2
        ];

        systemd.user.services.mpdris2 = {
            Unit = {
                Description = "MPD MPRIS bridge";
                After = [ "mpd.service" ];
            };

            Service = {
                ExecStart = "${pkgs.mpdris2}/bin/mpDris2";
                Restart = "always";
            };

            Install = {
                WantedBy = [ "default.target" ];
            };
        };

        programs.ags = {
            enable = true;
            configDir = ./.;
            extraPackages = with pkgs.astal; [
                io
                gjs
                astal4

                bluetooth 
                mpris
            ];
        };
    };
}
