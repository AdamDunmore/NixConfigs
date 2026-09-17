{ config, lib, pkgs, ... }:

let
    cfg = config.settings.modules.nixos.services.battery;
    limit = l:
        "${pkgs.bash}/bin/bash -c ''
            for battery in /sys/class/power_supply/BAT*; do
                [ -d \"\$battery\" ] || continue

                limit=\"\$battery/charge_control_end_threshold\"

                if [ -w \"\$limit\" ]; then
                    echo ${lib.toString l} > \"\$limit\"
                fi
            done
        ''";
    inherit (lib) mkIf;
in
{
    config = mkIf cfg.enable {
        systemd.services.battery-charge-limit = {
            description = "Set battery charge limit";
            wantedBy = [ "multi-user.target" ];

            serviceConfig = {
                Type = "oneshot";

                ExecStart = limit cfg.chargeLimit;

                ExecStop = limit 100;
            };
        };
    };
}
