{ config, pkgs, lib, colours, ... }:

let
    cfg = config.settings.home.widgets.waybar;
    locker = config.settings.home.wm.defaults.locker;
    inherit (lib) mkIf;
in
{
    config = mkIf cfg {
        programs.waybar = {
            enable = true;
            systemd.enable = true;
            settings = {
                mainBar = {
                    layer = "top";
                    position = "top";
                    height = 30;
                    spacing = 30;
                    fixed-center = true;

                    modules-left = [ "sway/workspaces" "dwl/tags" "custom/margin" "cava" ];
                    modules-center = [ "clock" "clock#date" ];
                    modules-right = [ "backlight" "pulseaudio" "battery" "network" "custom/margin" ];

                    "backlight" = {
                        format = "󰃠    {percent}%";
                        tooltip = false;
                    };

                    "pulseaudio" = {
                        format = "   {volume}%";
                        on-click = "${config.home.homeDirectory}/.scripts/sinkcycle.sh";
                    };

                    "battery" = {
                        format = "{icon} {capacity}%";
                        format-charging = "󰂄 {capacity}%";
                        format-icons = [ "󰁻" "󰁽" "󰁿" "󰂁" "󰁹" ];
                        on-click = "${config.home.homeDirectory}/.scripts/powercycle.sh";
                    };

                    "cava" = {
                        format-icons = ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█" ];
                        bar_delimiter = 0;
                        method = "pipewire";
                        bars = 12;
                        stereo = false;
                    };

                    "network" = {
                        format-wifi = "i    {signalStrength}%";
                        tooltip-format = "{essid} {frequency}GHz {bandwidthDownBytes}:{bandwidthUpBytes}";
                    };

                    "clock" = {
                        format = "{:%H:%M}";
                        tooltip-format = "{:%H:%M:%S}";
                    };
                    "clock#date" = {
                        format = "{:%A, %d %b %Y} ";
                        tooltop = false;
                    };

                    "custom/margin" = {
                        format = " ";
                    };
                };

            };
            style = ''
                window#waybar {
                    background-color: ${colours.blue.one};
                }

                #workspaces button {
                    transition: background-color 0.2s;
                }

                #workspaces button.focused {
                    background-color: ${colours.blue.two};
                }

                #workspaces button.urgent {
                    background-color: ${colours.blue.three};
                }

                #tags button:not(.occupied):not(.focused) {
                    opacity: 0;
                    padding: 0;
                    margin: 0;
                    min-width: 0;
                }
            '';
        };     
    };
}
