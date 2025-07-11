{ config, lib, colours, ... }:

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
                    modules-right = [ "backlight" "pulseaudio" "battery" "network" ];

                    "backlight" = {
                      format = "󰃠    {percent}%";
                    };

                    "pulseaudio" = {
                      format = "   {volume}%";
                    };

                    "battery" = {
                        format = "{icon} {capacity}%";
                        format-charging = "󰂄 {capacity}%";
                        format-icons = [ "󰁻" "󰁽" "󰁿" "󰂁" "󰁹" ];
                    };

                    "network" = {
                      format-wifi = "i    {signalStrength}%";
                    };

                    "clock" = {
                      format = "{:%H:%M}";
                    };
                    "clock#date" = {
                      format = "{:%A, %d %b %Y} ";
                    };
                };
            #     sideBar = {
            #         layer = "top";
            #         position = "right";
            #         width = 10;
            #         spacing = 30;
            #         fixed-center = true;
            #
            #         modules-left = [ "mpris" ];
            #         modules-center = [];
            #         modules-right = [ "custom/power_lock" "custom/power_sleep" "custom/power_restart" "custom/power_off" "custom/margin" ];
            #
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
            #         "custom/power_off" = {
            #             on-click = "shutdown now";
            #             format = "⏻  ";
            #         };
            #
            #         "custom/power_restart" = {
            #             on-click = "reboot";
            #             format = "󰜉  ";
            #         };
            #
            #         "custom/power_sleep" = {
            #             on-click = "systemctl suspend";
            #             format = "󰤄  ";
            #         };
            #
            #         "custom/power_lock" = {
            #             on-click = "${locker}/bin/${locker.meta.mainProgram}";
            #             format = "  ";
            #         };
            #
            #         "custom/margin" = {
            #             format = " ";
            #         };
            #     };
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
