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
                    fixed-center = true;
                    height = 20;
                    spacing = 5;
                    margin-top = 5;
                    margin-left = 10;
                    margin-right = 10;

                    modules-left = [  "mango/keymode" "niri/workspaces" "sway/workspaces" "mango/workspaces" ];
                    modules-center = [ "clock" "clock#date" ];
                    modules-right = [ "group/power" "battery" "custom/sidebar" ];

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
                            on-discharging-warning = "notify-send -u normal '󰁽 Low Battery' 'Please charge soon' & powerprofilesctl set power-saver";
                            on-discharging-critical = "notify-send -u normal '󰁻 Battery Critical' 'Device must be charged' & powerprofilesctl set power-saver";
                            on-charging-100 = "notify-send -u normal '󰁹 Battery Full' 'Remove from charger to preserve battery health'";
                            on-discharging = "notify-send -u normal '󰚦 Power Switch' 'Charger removed'";
                            on-charging = ''notify-send -u normal '󰚥 Power Switch' 'Device now charging' && powerprofilesctl set performance'';
                        };
                    };

                    "clock" = {
                        format = "{:%H:%M}";
                        tooltip-format = "{:%H:%M:%S}";
                    };
                    "clock#date" = {
                        format = "{:%a, %d %b %y}";
                        tooltip-format = "<small>{calendar}</small>";
                        calendar = {
                            mode = "year";
                            mode-mon-col = 4;
                            weeks-pos = "right";
                            first-day-of-week = 1;
                            format = {
                                months = "<span color='${colours.bg_selected}'><b>{}</b></span>";
                                days = "<span color='${colours.bg}'>{}</span>";
                                weeks = "<span color='${colours.base}'><b>|{}</b></span>";
                                weekdays = "<span color='${colours.bg_selected}'><b>{}</b></span>";
                                today = "<span color='${colours.fg}'><b>{}</b></span>";
                            };
                        };
                    };
                    
                    "mango/workspaces" = {
                        hide-empty = false;
                        on-click = "activate";
                    };

                    "mango/keymode" = {
                        format-default = " Default";
                        format-resize = "󰩨 Resize";
                    };

                    "custom/sidebar" = {
                        format = " 󰍜 ";
                        on-click = "ags request toggle";
                        tooltip = false;
                    };

                    "group/power" = {
                        orientation = "horizontal";
                        drawer = {
                            transition-duration = 500;
                            children-class = "not-power";
                            transition-left-to-right = false;
                        };
                        modules = [
                            "custom/power"
                            "custom/reboot"
                            "custom/sleep"
                            "custom/lock"
                        ];
                    };

                    "custom/power" = {
                        format = " ⏻ ";
                        tooltip = false;
                        on-click = "shutdown now";
                    };

                    "custom/reboot" = {
                        format = " 󰜉 ";
                        tooltip = false;
                        on-click = "reboot";
                    };

                    "custom/sleep" = {
                        format = " 󰤄 ";
                        tooltip = false;
                        on-click = "systemctl suspend";
                    };

                    "custom/lock" = {
                        format = "  ";
                        tooltip = false;
                        on-click = "hyprlock";
                    };
                };

            };
            style = ''
                * {
                    color: ${colours.fg};
                }

                window#waybar {
                    background-color: rgba(0,0,0,0);
                }

                button, #power label, .not-power label {
                    font-size: 14px;
                    padding: 0px;
                    border: none;
                    box-shadow: none; /* Remove predefined box-shadow */
                    text-shadow: none; /* Remove predefined text-shadow */
                }

                button:hover, #power label, .not-power label {
                    color: ${colours.fg};
                    background: none; /* Remove predefined background color (white) */
                    transition: none; /* Disable predefined animations */
                }

                #backlight,
                #battery,
                #clock,
                #date,
                #pulseaudio,
                #network,
                #keymode,
                #custom-power,
                #custom-reboot,
                #custom-sleep,
                #custom-lock,
                #custom-sidebar {
                    color: ${colours.fg};
                    background-color: alpha(${colours.bg}, 0.5);
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
                #custom-power:hover,
                #custom-reboot:hover,
                #custom-sleep:hover,
                #custom-lock:hover,
                #custom-sidebar:hover {
                    background-color: alpha(${colours.bg}, 0.8); 
                }

                #battery.warning {
                    background-color: #AA9930;
                }

                #battery.critical {
                    background-color: #AA5555;
                }

                #power, .not-power {
                    background-color: rgba(0,0,0,0);
                }

                #workspaces button:first-child {
                    border-radius: 10px 0 0 10px;
                }

                #workspaces button:last-child {
                    border-radius: 0 10px 10px 0;
                }

                #workspaces button {
                    padding: 5px;
                    padding-left: 10px;
                    padding-right: 10px;
                    background-color: alpha(${colours.bg}, 0.5);
                    border-radius: 0px;
                    transition: background-color 0.75s;
                }

                #workspaces button.empty {
                    background-color: alpha(${colours.base}, 0.5);
                }

                #workspaces button.active {
                    background-color: ${colours.bg};
                }

                #workspaces button.urgent {
                    background-color: ${colours.bg_urgent};
                }

                #workspaces button:hover {
                    background-color: ${colours.bg_selected};
                }
            '';
        };     
    };
}
