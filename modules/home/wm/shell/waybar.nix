{ config, lib, inputs, system, ... }:

let
    cfg = config.settings.modules.home.wm.shell.waybar;
    colours = config.settings.values.colours;
    inherit (lib) mkIf;
in
{
    config = mkIf cfg.enable {
        programs.waybar = {
            enable = true;
            package = inputs.waybar.packages.${system}.waybar.overrideAttrs(old: {
                doCheck = false;
                mesonFlags = (old.mesonFlags or []) ++ [
                    "-Dtests=disabled"
                ];
            });
            settings = {
                mainBar = {
                    layer = "top";
                    position = "top";
                    height = 20;
                    spacing = 5;
                    margin-top = 5;
                    margin-bottom = 5;
                    fixed-center = true;

                    modules-left = [ "sway/workspaces" "mango/workspaces" "custom/margin" ];
                    modules-center = [ "clock" "clock#date" ];
                    modules-right = [ "backlight" "pulseaudio" "battery" "network" "custom/settings" "custom/sidebar" "custom/margin" ];

                    "backlight" = {
                        format = "{icon} {percent}%";
                        format-icons = [ "󰃞" "󰃟" "󰃠" ];
                        tooltip = false;
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
                    };

                    "network" = {
                        format-wifi = "{icon}  {signalStrength}%";
                        format-icons = [ "󰤯" "󰤟" "󰤢" "󰤥" "󰤨" ];
                        tooltip-format = "{essid} {frequency}GHz {bandwidthDownBytes}:{bandwidthUpBytes}";
                    };

                    "clock" = {
                        format = "{:%H:%M}";
                        tooltip-format = "{:%H:%M:%S}";
                    };
                    "clock#date" = {
                        format = "{:%A, %d %b %Y}";
                        tooltop = false;
                    };
                    
                    "mango/workspaces" = {
                        hide-empty = true;
                        on-click = "activate";
                    };

                    "custom/sidebar" = {
                        format = " 󰍜 ";
                        on-click = "ags request toggle_sidebar";
                        tooltip = false;
                    };

                    "custom/settings" = {
                        format = " 󰒓 ";
                        on-click = "ags request toggle_menu";
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

                button {
                    padding: 0px;
                    border: none;
                    box-shadow: none; /* Remove predefined box-shadow */
                    text-shadow: none; /* Remove predefined text-shadow */
                }

                button:hover {
                    background: none; /* Remove predefined background color (white) */
                    transition: none; /* Disable predefined animations */
                }

                #workspaces button.active {
                    background-color: ${colours.blue.two};
                }

                #workspaces button.urgent {
                    background-color: ${colours.blue.three};
                }

                #workspaces button:hover {
                    background-color: ${colours.blue.two};
                }

                #custom-margin {
                    background-color: rgba(0,0,0,0);
                }

                #backlight,
                #battery,
                #clock,
                #date,
                #pulseaudio,
                #network,
                #custom-sidebar,
                #custom-settings,
                #workspaces button {
                    color: ${colours.white.one};
                    background-color: ${colours.blue.one};
                    padding-left: 10px;
                    padding-right: 10px;
                    border-radius: 25px;
                    transition: background-color 0.2s;

                    margin-left: 2px;
                    margin-right: 2px;
                }
            '';
        };     
    };
}
