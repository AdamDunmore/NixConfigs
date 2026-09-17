{ lib, config, ... }:
let
    inherit (lib) mkOption mkEnableOption types;
    
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
    options.settings.modules.home.wm.module = {
        enable = mkOption {
            type = lib.types.bool;
            default = config.settings.modules.home.wm.enable;
            example = false;
            description = "Enables the wm module";
        };
    
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
                    default = 1.0;
                    example = 0.1;
                    description = "How much to dim active window by";
                };
    
                inactive = mkOption {
                    type = types.float;
                    default = 1.0;
                    example = 0.1;
                    description = "How much to dim inactive window by";
                };
            };
        };  
    };
}
