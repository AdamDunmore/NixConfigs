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

        systemd.services.cpu-power-profile = { 
            description = "Apply CPU frequency limit based on power profile"; 
            wantedBy = [ "multi-user.target" ]; 
            serviceConfig = { 
                Type = "simple"; 
                  ExecStart = pkgs.writeShellScript "cpu-power-profile" ''
                    normal_max="$(cat /sys/devices/system/cpu/cpufreq/policy0/scaling_max_freq)"

                    set_limit() {
                        case "$1" in
                            power-saver)
                                limit=2000000
                                ;;

                            performance)
                                limit=4059140
                                ;;

                            *)
                                return
                                ;;
                        esac

                        for policy in /sys/devices/system/cpu/cpufreq/policy*; do
                            if [ -w "$policy/scaling_max_freq" ]; then
                                echo "$limit" > "$policy/scaling_max_freq"
                            fi
                        done
                    }

                    last_profile=""

                    while true; do
                        profile="$(${pkgs.power-profiles-daemon}/bin/powerprofilesctl get)"

                        if [ "$profile" != "$last_profile" ]; then
                            set_limit "$profile"
                            last_profile="$profile"
                        fi

                        sleep 1
                    done
                '';
                Restart = "always"; 
                RestartSec = 1; 
            }; 
        };
    };
}
