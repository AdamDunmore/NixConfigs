{ config, lib, colours, ... }:

let
    cfg = config.settings.home.widgets.waybar;
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
                    height = 20;
                    spacing = 5;
                    margin-top = 5;
                    margin-bottom = 5;
                    fixed-center = true;

                    modules-left = [ "sway/workspaces" "dwl/tags" "custom/margin" ];
                    modules-center = [ "clock" "clock#date" ];
                    modules-right = [ "backlight" "pulseaudio" "battery" "network" "custom/sidebar" "custom/margin" ];

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

                    "cava" = { # TODO Re-add in AGS
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

                    "custom/sidebar" = {
                        format = " 󰍜 ";
                        on-click = "ags request toggle";
                        tooltip = false;
                    };

                    "custom/margin" = {
                        format = " ";
                    };
                };

            };
            style = ''
                window#waybar {
                    background-color: rgba(0,0,0,0);
                }

                button, label {
                    background-color: ${colours.blue.one};
                    border-radius: 25px;

                    margin-left: 2px;
                    margin-right: 2px;
                }

                #tags button,
                #workspaces button {
                    padding-left: 10px;
                    padding-right: 10px;
                    transition: background-color 0.2s;
                }

                #tags button.focused,
                #workspaces button.focused {
                    background-color: ${colours.blue.two};
                }

                #tags button.urgent,
                #workspaces button.urgent {
                    background-color: ${colours.blue.three};
                }

                #tags button:not(.occupied):not(.focused) {
                      font-size: 0;
                      min-width: 0;
                      min-height: 0;
                      margin: -17px;
                      padding: 0;
                      border: 0;
                      opacity: 0;
                      box-shadow: none;
                      background-color: transparent;
                }

                #custom-margin {
                    background-color: rgba(0,0,0,0);
                }

                #backlight,
                #battery,
                #clock,
                #date,
                #pulseaudio,
                #network {
                    padding-left: 10px;
                    padding-right: 10px;
                }
            '';
        };     
    };
}
