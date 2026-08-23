{ pkgs, lib, config, ... }:

let
  cfg = config.settings.modules.home.apps.scripts;

  ss = pkgs.writeShellScriptBin "systemstats" ''
    # CPU usage
    read -r _ user nice system idle iowait irq softirq steal _ < /proc/stat
    idle=$((idle + iowait))
    total=$((user + nice + system + idle + irq + softirq + steal))

    sleep 1

    read -r _ user2 nice2 system2 idle2 iowait2 irq2 softirq2 steal2 _ < /proc/stat
    idle2=$((idle2 + iowait2))
    total2=$((user2 + nice2 + system2 + idle2 + irq2 + softirq2 + steal2))

    cpu=$(awk \
      -v idle="$idle" \
      -v idle2="$idle2" \
      -v total="$total" \
      -v total2="$total2" \
      'BEGIN {
        printf "%.1f", 100 * (1 - (idle2-idle)/(total2-total))
      }')


    # RAM usage
    mem_total=$(awk '/^MemTotal:/ {print $2}' /proc/meminfo)
    mem_available=$(awk '/^MemAvailable:/ {print $2}' /proc/meminfo)

    ram=$(awk \
      -v total="$mem_total" \
      -v available="$mem_available" \
      'BEGIN {
        printf "%.1f", 100 * (1 - available/total)
      }')


    # GPU utilisation (AMD)
    gpu=$(cat /sys/class/drm/card*/device/gpu_busy_percent 2>/dev/null | head -n1)
    gpu=''${gpu:-0}


    # Temperatures
    cpu_temp=$(sensors 2>/dev/null |
      awk '/Tctl:/ {
        gsub(/[+°C]/, "", $2)
        print $2
        exit
      }')

    gpu_temp=$(sensors 2>/dev/null |
      awk '/edge:/ {
        gsub(/[+°C]/, "", $2)
        print $2
        exit
      }')


    # JSON
    jq -n \
      --argjson cpu "''${cpu:-0}" \
      --argjson ram "''${ram:-0}" \
      --argjson cpu_temp "''${cpu_temp:-0}" \
      --argjson gpu "''${gpu:-0}" \
      --argjson gpu_temp "''${gpu_temp:-0}" \
      '{
        cpu: $cpu,
        ram: $ram,
        cpu_temp: $cpu_temp,
        gpu: $gpu,
        gpu_temp: $gpu_temp
      }'
  '';

  inherit (lib) mkIf;

in
{
  config = mkIf cfg.enable {
    home.packages = [ ss ];

    xdg.desktopEntries.systemstats = {
      name = "ss";
      genericName = "System Stats";
      exec = "${ss}/bin/systemstats";
      terminal = false;
    };
  };
}
