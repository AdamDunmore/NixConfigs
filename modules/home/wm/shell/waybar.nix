{ config, lib, inputs, pkgs, ... }:

let
    cfg = config.settings.modules.home.wm.shell.waybar;
    colours = config.settings.values.colours;
    waybar = import ../../../../pkgs/waybar.nix { inherit pkgs; inherit inputs; };
    inherit (lib) mkIf;
in
{
    config = mkIf cfg.enable {
        programs.waybar = {
            enable = true;
            package = waybar;
            settings = {
                mainBar = {
                    layer = "top";
                    position = "top";
                    height = 20;
                    spacing = 5;
                    margin-top = 5;
                    margin-bottom = 5;
                    fixed-center = true;

                    modules-left = [ "custom/margin" "niri/workspaces" "sway/workspaces" "mango/workspaces" "custom/margin" ];
                    modules-center = [ "clock" "clock#date" ];
                    modules-right = [ "backlight" "pulseaudio" "battery" "custom/sidebar" "custom/margin" ];

                    "backlight" = {
                        format = "{icon} {percent}%";
                        format-icons = [ "󰃞" "󰃟" "󰃠" ];
                        tooltip = false;
                        on-click = "togglenight";
                    };

                    "pulseaudio" = {
                        format = "{icon} {volume}%";
                        format-icons = [ " " "" "" ""];
                        on-click = "sinkcycle";
                    };

                    "battery" = {
                        format = "{icon} {capacity}%";
                        format-charging = "󰂄 {capacity}%";
                        format-icons = [ "󰁻" "󰁽" "󰁿" "󰂁" "󰁹" ];
                        on-click = "powercycle";
                        interval = 1;
                        states = {
                            warning = 30;
                            critical = 15;
                        };
                        events = {
                            on-discharging-warning = "notify-send -u normal 'Low Battery' & powerprofilesctl set power-saver";
                            on-discharging-critical = "notify-send -u normal 'Battery Critical' & powerprofilesctl set power-saver";
                            on-charging-100 = "notify-send -u normal 'Battery Full!'";
                            on-discharging = "notify-send -u normal 'Power Switch' Discharging";
                            on-charging = "notify-send -u normal 'Power Switch' Charging & powerprofilesctl set performance";
                        };
                    };

                    "clock" = {
                        format = "{:%H:%M}";
                        tooltip-format = "{:%H:%M:%S}";
                    };
                    "clock#date" = {
                        format = "{:%A, %d %b %Y}";
                        tooltip = false;
                    };
                    
                    "mango/workspaces" = {
                        hide-empty = false;
                        on-click = "activate";
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

                #custom-margin {
                    background-color: rgba(0,0,0,0);
                }

                button {
                    font-size: 14px;
                    padding: 0px;
                    border: none;
                    box-shadow: none; /* Remove predefined box-shadow */
                    text-shadow: none; /* Remove predefined text-shadow */
                }

                button:hover {
                    color: ${colours.white.one};
                    background: none; /* Remove predefined background color (white) */
                    transition: none; /* Disable predefined animations */
                }

                #backlight,
                #battery,
                #clock,
                #date,
                #pulseaudio,
                #network,
                #custom-sidebar {
                    color: ${colours.white.one};
                    background-color: alpha(${colours.blue.one}, 0.5);
                    padding-left: 10px;
                    padding-right: 10px;
                    border-radius: 10px;
                    transition: background-color 0.25s;

                    margin-left: 2px;
                    margin-right: 2px;
                }

                #backlight:hover,
                #battery:hover,
                #pulseaudio:hover,
                #custom-sidebar:hover,
                #custom-settings:hover {
                    background-color: alpha(${colours.blue.one}, 0.8); 
                }

                #battery.warning {
                    background-color: #AA9930;
                }

                #battery.critical {
                    background-color: #AA5555;
                }

                #workspaces button:first-child {
                    border-radius: 10px 0 0 10px;
                }

                #workspaces button:last-child {
                    border-radius: 0 10px 10px 0;
                }

                #workspaces button {
                    padding: 5px;
                    background-color: alpha(${colours.blue.one}, 0.5);
                    border-radius: 0px;
                    transition: background-color 0.75s;
                }

                #workspaces button.empty {
                    background-color: alpha(${colours.blue.two}, 0.5);
                }

                #workspaces button.active {
                    background-color: ${colours.blue.one};
                }

                #workspaces button.urgent {
                    background-color: ${colours.blue.three};
                }

                #workspaces button:hover {
                    background-color: ${colours.blue.two};
                }
            '';
        };     
    };
}
