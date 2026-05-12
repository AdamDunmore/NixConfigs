{ config, lib, inputs, ... }:
let
    cfg = config.wm;
    inherit (lib) mkOption mkEnableOption types mkDefault;

    mkColourOption = s: mkOption {
        type = types.str;
        default = "#000000";
        example = "#FFFFFF";
        description = s;
    };
in
{
    # imports = [ inputs.mango.hmModules.mango-ext ];
    options.wm = {
        modifier = mkOption {
            type = types.enum [ "SUPER" "Alt" ];
            default = "SUPER";
            example = "SUPER";
            description = "The modifier key for the wm";
        };
        input = {
            keyboard = {
                layout = mkOption {
                    type = types.str;
                    default = "gb";
                    example = "us";
                    description = "The keyboard language to use";
                };
            };
            
            mouse = {
                accel = mkEnableOption "Enables mouse acceleration";
                tap = mkEnableOption "Enable trackpad tap to click";
                natural_scroll = mkEnableOption "Enable trackpad scroll";
            };
        };
        gaps = {
            inner = mkOption {
                type = types.int;
                default = 0;
                example = 10;
                description = "Size of the inner gaps";
            };

            outer = mkOption {
                type = types.int;
                default = 0;
                example = 10;
                description = "Size of the outer gaps";
            };

            smartGaps = mkEnableOption "Enable smart gaps";
            smartBorders = mkEnableOption "Enable smart borders";
        };

        colours = {
            focused = {
                background = mkColourOption "The background colour of the focused window";
                border = mkColourOption "The border colour of the focused window";
                indicator = mkColourOption "The indicator colour of the focused window";
                text = mkColourOption "The text colour of the focused window";
            };
            unfocused = {
                background = mkColourOption "The background colour of the unfocused window";
                border = mkColourOption "The border colour of the unfocused window";
                indicator = mkColourOption "The indicator colour of the unfocused window";
                text = mkColourOption "The text colour of the unfocused window";
            };
        };

        startup = mkOption {
            type = types.listOf types.str;
            default = [];
            example = [ "ags run" "waybar" ];
            description = "A list of programs to run on startup";
        };

        startup_always = mkOption {
            type = types.listOf types.str;
            default = [];
            example = [ "ags run" "waybar" ];
            description = "A list of programs to run always on startup";
        };

        window = {
            border = mkOption {
                type = types.int;
                default = 0;
                example = 10;
                description = "Size of window border";
            };

            border_radius = mkOption {
                type = types.int;
                default = 0;
                example = 10;
                description = "Size of window border radius";
            };

            dim = {
                active = mkOption {
                    type = types.float;
                    default = 1;
                    example = 0.1;
                    description = "How much to dim active window by";
                };

                inactive = mkOption {
                    type = types.float;
                    default = 1;
                    example = 0.1;
                    description = "How much to dim inactive window by";
                };
            };
        };  
    };
    config = {
        wayland.windowManager.mango-ext = let
            hexToMango = c: builtins.replaceStrings ["#"] ["0x"] c;
            mod = ( 
                if cfg.modifier == "SUPER" then "SUPER"
                else if cfg.modifier == "Alt" then "ALT"
                else "SUPER"
            );
        in {
            settings = {
                exec = cfg.startup_always;
                exec-once = cfg.startup;

                xkb_rules_layout=cfg.input.keyboard.layout;
                mouse_accel_profile= if cfg.input.mouse.accel then 2 else 1;
                trackpad_natural_scrolling = if cfg.input.mouse.natural_scroll then 1 else 0;
                tap_to_click = if cfg.input.mouse.tap then 1 else 0;

                border_radius = cfg.window.border_radius;
                unfocused_opacity = cfg.window.dim.inactive;
                borderpx = cfg.window.border;
                smartgaps = if cfg.gaps.smartGaps then 1 else 0;
                no_border_when_single = if cfg.gaps.smartBorders then 1 else 0;

                gappih = cfg.gaps.inner;
                gappiv = cfg.gaps.inner;
                gappoh = cfg.gaps.outer;
                gappov = cfg.gaps.outer;

                bordercolor = hexToMango cfg.colours.focused.border; 
                focuscolor = hexToMango cfg.colours.focused.indicator;
            };
        };
        wayland.windowManager.sway = let 
            mod = (
                if cfg.modifier == "SUPER" then "Mod4"
                else if cfg.modifier == "Alt" then "Mod1"
                else "Mod4"
            );
        in {
            config = {
                floating.modifier = "${mod}";
                input."*" = {
                    xkb_layout = cfg.input.keyboard.layout;
                    accel_profile = (if cfg.input.mouse.accel then "adaptive" else "flat");
                    tap = (if cfg.input.mouse.tap then "enabled" else "disabled");
                    natural_scroll = (if cfg.input.mouse.natural_scroll then "enabled" else "disabled");
                };

                colors = {
                    focused = {
                        background = cfg.colours.focused.background;
                        border = cfg.colours.focused.border;
                        childBorder = cfg.colours.focused.border;
                        indicator = cfg.colours.focused.indicator;
                        text = cfg.colours.focused.text;
                    };
                    unfocused = {
                        background = cfg.colours.unfocused.background;
                        border = cfg.colours.unfocused.border;
                        childBorder = cfg.colours.unfocused.border;
                        indicator = cfg.colours.unfocused.indicator;
                        text = cfg.colours.unfocused.text;
                    };
                };

                startup = 
                    (map (cmd: { command = cmd; }) cfg.startup) ++
                    (map (cmd: { command = cmd; always = true; }) cfg.startup_always);
                gaps = {
                    inner = cfg.gaps.inner;
                    outer = cfg.gaps.outer;
                    smartGaps = cfg.gaps.smartGaps;
                    smartBorders = (if cfg.gaps.smartBorders then "on" else "off");
                };

                window = {
                    border = cfg.window.border;
                };
            };
            extraConfig = ''
                corner_radius ${toString cfg.window.border_radius}
                default_dim_inactive ${toString (1 - cfg.window.dim.inactive)}
            '';
        };
    };
}
