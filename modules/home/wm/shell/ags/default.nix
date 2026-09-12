{ inputs, pkgs, config, lib, ... }:
let
    cfg = config.settings.modules.home.wm.shell.ags;
    notification_monitor = import ./notification_monitor.nix { inherit pkgs; };
    inherit (lib) mkIf;
in
{
    imports = [ inputs.ags.homeManagerModules.default ];

    config = mkIf cfg.enable {
        home.packages = with pkgs; [ 
            gammastep 
            mpdris2
            lm_sensors
            gcalcli
            notification_monitor
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

                apps
                brightness
                cava
                bluetooth 
                network
                mpris
                powerprofiles
                wireplumber
            ];
        };
    };
}
