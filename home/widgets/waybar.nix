{ config, pkgs, lib, colours, ... }:

let
    cfg = config.settings.home.widgets.waybar;
    locker = config.settings.home.wm.defaults.locker;
in
with lib;
{
    config = mkIf cfg {
        programs.waybar = {
            enable = true;
            settings = {
                mainBar = {
                    layer = "top";
                    position = "top";
                    height = 30;
                    spacing = 30;
                    fixed-center = true;

                    modules-left = [ "sway/workspaces" ];
                    modules-center = [ "clock" "clock#date" ];
                    modules-right = [ "backlight" "pulseaudio" "battery" "network" "custom/margin" ];

                    "backlight" = {
                        format = "󰃠    {percent}%";
                        tooltip = false;
                    };

                    "pulseaudio" = {
                        format = "   {volume}%";
                        on-click = "~/.scripts/sinkcycle.sh";
                    };

                    "battery" = {
                        format = "{icon} {capacity}%";
                        format-charging = "󰂄 {capacity}%";
                        format-icons = [ "󰁻" "󰁽" "󰁿" "󰂁" "󰁹" ];
                        on-click = "~/.scripts/powercycle.sh";

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

            #         "mpris"= {
            #             format = "{player_icon}\n{title}\n{artist}";
            #             format-paused = "{status_icon}\n{title}\n{artist}\n{player}\n{length}";
            #             rotate = 1;
            #             player-icons = {
            #                 default = "▶";
            #                 mpv = "🎵";
            #                 spotify = "";
            #             };
            #             status-icons = {
            #                 paused = "⏸";
            #             };
            #             ignored-players = ["firefox"];
            #         };
            #

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
            '';
        };     
    };
}
