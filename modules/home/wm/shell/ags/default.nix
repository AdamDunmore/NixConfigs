{ inputs, pkgs, config, lib, system, ... }:
let
    cfg = config.settings.modules.home.wm.shell.ags;
    notification_monitor = import ./notification_monitor.nix { inherit pkgs; };
    astal_pkgs = inputs.astal.packages.${system};
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
            extraPackages = with astal_pkgs; [
                pkgs.gjs
                pkgs.networkmanager

                astal4
                io
                apps
                brightness
                bluetooth 
                network
                mpris
                powerprofiles
                wireplumber
                wl
            ];
        };
    };
}
