{ config, lib, inputs, pkgs, ... }:
let
    cfg = config.wm;
    inherit (lib) mkOption mkEnableOption types mkDefault;

    mkKeybindOption = s: mkOption {
        default = [];
        example = [ { mod = true; key = "Return"; dispatch = "spawn"; arg = "alacritty"; } ];
        description = s;
        type = types.listOf (types.submodule {
            options = {
                mod = mkEnableOption "Add mod to bind";
                sub_mod = mkOption {
                    type = types.enum [ "SUPER" "CTRL" "ALT" "SHIFT" ""];
                    default = "";
                    example = "SHIFT";
                    description = "An additional modifier key to combo with the main one, leave unset for none";
                };
                key = mkOption {
                    type = types.str;
                    default = "G";
                    example = "Return";
                    description = "Key for keybind";
                };
                dispatch = mkOption {
                    type = types.enum [ "spawn" "spawn_shell" "kill" "reload" "focus" "move" "view_workspace" "move_workspace" "fullscreen" "floating" "mode" "resizev" "resizeh" ];
                    default = "spawn";                                                      
                    example = "kill";
                    description = "Dispatcher for bind";
                };
                arg = mkOption {
                    type = types.str;
                    default = "";
                    example = "alacritty";
                    description = "Any additional args for dispatcher";
                };
            };
        });
    };

    mkColourOption = s: mkOption {
        type = types.str;
        default = "#000000";
        example = "#FFFFFF";
        description = s;
    };
in
{
    options.wm = {
        modifier = mkOption {
            type = types.enum [ "SUPER" "ALT" ];
            default = "SUPER";
            example = "SUPER";
            description = "The modifier key for the wm";
        };
        keybinds = mkKeybindOption "A list of wm keybinds";

        modes = mkOption {
            type = types.listOf (types.submodule {
                options = {
                    name = mkOption {
                        type = types.str;
                        default = "default";
                        example = "resize";
                        description = "The name of the mode";
                    };
                    keybinds = mkKeybindOption "A list of keybinds for the mode";
                };
            });
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
            bindsToActions = binds : map (b: 
                "${if b.mod then mod else "NONE"}" + 
                "${if b.sub_mod == "" then "" else "+${b.sub_mod}"}," +
                "${b.key},${
                    if b.dispatch == "spawn" then "spawn" 
                    else if b.dispatch == "spawn_shell" then "spawn_shell"
                    else if b.dispatch == "kill" then "killclient" 
                    else if b.dispatch == "reload" then "reload_config"
                    else if b.dispatch == "focus" then "focusdir"
                    else if b.dispatch == "move" then "exchange_client"
                    else if b.dispatch == "view_workspace" then "view"
                    else if b.dispatch == "move_workspace" then "tagsilent"
                    else if b.dispatch == "fullscreen" then "togglefullscreen"
                    else if b.dispatch == "floating" then "togglefloating"
                    else if b.dispatch == "mode" then "setkeymode"
                    else if b.dispatch == "resizev" then "resizewin,0,${b.arg}"
                    else if b.dispatch == "resizeh" then "resizewin,${b.arg},0"
                    else "spawn"}," +
                "${if b.dispatch == "resizev" || b.dispatch == "resizeh" then "" else b.arg}"
            ) binds;
            mod = ( 
                if cfg.modifier == "SUPER" then "SUPER"
                else if cfg.modifier == "ALT" then "ALT"
                else "SUPER"
            );
        in {
            settings = {
                bind = bindsToActions cfg.keybinds;
 
                keymode = builtins.listToAttrs (map (m: {
                    name = m.name;
                    value = {
                        bind = bindsToActions m.keybinds;
                    };
                }) cfg.modes );

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
            bindsToActions = binds : builtins.listToAttrs (map (b: {
                name = 
                    "${if b.mod then "${mod + "+"}" else ""}" +
                    "${if b.sub_mod == "" then "" else "${b.sub_mod + "+"}"}" +
                    "${b.key}";

                value =
                    "${
                        if b.dispatch == "spawn" then "exec" 
                        else if b.dispatch == "spawn_shell" then "exec"
                        else if b.dispatch == "kill" then "kill" 
                        else if b.dispatch == "reload" then "reload"
                        else if b.dispatch == "focus" then "focus"
                        else if b.dispatch == "move" then "move"
                        else if b.dispatch == "view_workspace" then "exec ${pkgs.swaysome}/bin/swaysome focus"
                        else if b.dispatch == "move_workspace" then "exec ${pkgs.swaysome}/bin/swaysome move"
                        else if b.dispatch == "fullscreen" then "fullscreen"
                        else if b.dispatch == "floating" then "floating toggle"
                        else if b.dispatch == "mode" then "mode"
                        else if b.dispatch == "resizev" then "resize grow height ${b.arg}px"
                        else if b.dispatch == "resizeh" then "resize grow width ${b.arg}px"
                        else "spawn"
                    }" +
                    "${if b.dispatch == "resizev" || b.dispatch == "resizeh" then "" else " ${b.arg}"}";
            }) binds);

            mod = (
                if cfg.modifier == "SUPER" then "Mod4"
                else if cfg.modifier == "ALT" then "Mod1"
                else "Mod4"
            );
        in {
            config = {
                floating.modifier = "${mod}";

                keybindings = bindsToActions cfg.keybinds; 
                input."*" = {
                    xkb_layout = cfg.input.keyboard.layout;
                    accel_profile = (if cfg.input.mouse.accel then "adaptive" else "flat");
                    tap = (if cfg.input.mouse.tap then "enabled" else "disabled");
                    natural_scroll = (if cfg.input.mouse.natural_scroll then "enabled" else "disabled");
                };

                modes = builtins.listToAttrs (map (m: {
                    name = m.name;
                    value = bindsToActions m.keybinds;
                }) cfg.modes);

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
