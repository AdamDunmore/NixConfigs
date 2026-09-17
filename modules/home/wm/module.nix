{ lib, config, pkgs, ... }:
let
    cfg = config.settings.modules.home.wm.module;
    inherit (lib) mkIf;
in
{
    config = mkIf cfg.enable {
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
        wayland.windowManager.niri = let
            mod = ( 
                if cfg.modifier == "SUPER" then "Mod"
                else if cfg.modifier == "ALT" then "Alt"
                else "Mod"
            );
            bindsToActions = binds: lib.mergeAttrsList (map (b: {
                ${
                    "${if b.mod then mod + "+" else ""}" + 
                    "${if b.sub_mod == "" then "" else "${b.sub_mod}+"}" +
                    "${b.key}"
                }
                .
                "${
                    if b.dispatch == "spawn" then "spawn" 
                    else if b.dispatch == "spawn_shell" then "spawn-sh"
                    else if b.dispatch == "kill" then "close-window" 
                    else if b.dispatch == "reload" then "spawn"
                    else if b.dispatch == "focus" then (if b.arg == "left" || b.arg == "right" then "focus-column-${b.arg}" else "focus-window-${b.arg}")
                    else if b.dispatch == "move" then (if b.arg == "left" || b.arg == "right" then "move-column-${b.arg}" else "move-window-${b.arg}")
                    else if b.dispatch == "view_workspace" then "focus-workspace"
                    else if b.dispatch == "move_workspace" then "move-window-to-workspace"
                    else if b.dispatch == "fullscreen" then "fullscreen-window"
                    else if b.dispatch == "floating" then "switch-focus-between-floating-and-tiling"
                    else if b.dispatch == "mode" then "spawn" # TODO change
                    else if b.dispatch == "resizev" then ""
                    else if b.dispatch == "resizeh" then ""
                    else "spawn"
                }" = (
                    if b.dispatch == "resizev" || b.dispatch == "resizeh" then {} 
                    else if b.dispatch == "focus" || b.dispatch == "move" then {}
                    else if b.dispatch == "view_workspace" || b.dispatch == "move_workspace" then [ (lib.toInt b.arg) ]
                    else if b.arg == "" then {}
                    else [ b.arg ]
                );
            }) binds);
        in {
            settings = {
                binds = bindsToActions cfg.keybinds;
    
                # keymode = builtins.listToAttrs (map (m: { # Doesnt exist on niri?
                #     name = m.name;
                #     value = {
                #         bind = bindsToActions m.keybinds;
                #     };
                # }) cfg.modes );
                #
                _children = 
                    (map (v: {
                        spawn-at-startup = v;
                    }) cfg.startup_always)
                    ++
                    (map (v: {
                        spawn-at-startup = v;
                    }) cfg.startup)
                    ++
                    [
                        {
                            window-rule = {
                                clip-to-geometry = true;
                                geometry-corner-radius = cfg.window.border_radius;
                            }; 
                        }
                        {
                            window-rule._children = [
                                { match._props = { is-active=false; }; }
                                { opacity = cfg.window.dim.inactive; }
                            ];
                        }
                    ];
    
                input = {
                    keyboard.xkb.layout = cfg.input.keyboard.layout;
                    touchpad = {
                        tap = if cfg.input.mouse.tap then {} else null;
                        natural-scroll = if cfg.input.mouse.natural_scroll then {} else null;
                        accel-profile = if cfg.input.mouse.accel then "adaptive" else "flat";
                    };
                    mouse.accel-profile = if cfg.input.mouse.accel then "adaptive" else "flat";
                };
    
                layout = {
                    gaps = cfg.gaps.outer;
                    border = {
                        width = cfg.window.border;
                        inactive-color = cfg.colours.focused.border; 
                        active-color = cfg.colours.focused.indicator;        
                    };
                };
            };
        };
    };
}
