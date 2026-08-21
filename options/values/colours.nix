{ lib, config, ... }:
let
    mkColourOption = colour: number: default: mkOption {
        type = lib.types.str;
        inherit default;
        example = "#000000";
        description = "Sets the hex value for ${colour} ${number}";
    };
    inherit (lib) mkOption;
in
{
    options.settings.values.colours = { # TODO rework into primary, secondary, etc...
        blue = {
            one = mkColourOption "Blue" 1 "#4C566A";
            two = mkColourOption "Blue" 2 "#3B4252";
            three = mkColourOption "Blue" 3 "#2E3440";
        };

        light_blue = {
            one = mkColourOption "Light Blue" 1 "#81A1C1";
            two = mkColourOption "Light Blue" 2 "#5E81AC";
        };

        white = {
            one = mkColourOption "White" 1 "#D8DEE9";
        };
    };
}
