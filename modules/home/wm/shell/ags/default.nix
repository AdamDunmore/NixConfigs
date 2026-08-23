{ inputs, pkgs, config, lib, ... }:
let
    cfg = config.settings.modules.home.wm.shell.ags;
    inherit (lib) mkIf;
in
{
    imports = [ inputs.ags.homeManagerModules.default ];

    config = mkIf cfg.enable {
        home.packages = with pkgs; [ 
            gammastep 
            mpdris2
            lm_sensors
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
                pkgs.networkmanager

                cava
                bluetooth 
                network
                mpris
            ];
        };
    };
}
