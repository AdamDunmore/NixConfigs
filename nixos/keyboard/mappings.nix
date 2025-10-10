{ pkgs, lib, config, ... }:

let
  cfg = config.settings.nixos.keyboard.custom_layout;
  inherit (lib) mkIf;
in
{
    config = mkIf cfg {
        # TODO
        # boot.kernelModules = [ "uinputs"];
        # hardware.uinput.enable = true;
        # services.evdevremapkeys = {
        #     enable = true;
        #     settings = {
        #         devices = [
        #             { 
        #                 input_name = "EasySMX EasySMX X10";
        #                 output_name = "remap-controller";
        #                 remappings = {
        #                     BTN_SOUTH = [ "KEY_Z" ];
        #                 };
        #             }
        #                 # input = "/dev/input/event6";
        #                 # grab = true;
        #                 # remappings = [
        #                 #     { from = "BTN_SOUTH"; to = "KEY_S"; }
        #                 # ];
        #         ];
        #     };
        # };
        services.keyd = {
            enable = true;
            keyboards.default = {
                settings = {
                    meta = {
                        esc = "oneshot(modeswitch)";  
                    };
                    modeswitch = {
                        esc = "setlayout(main)";
                        o = "toggle(onehanded)";
                    };
                    onehanded = {
                        esc = "clear()";
                        q = "leftmouse";
                        e = "rightmouse";
                    };


                    main = {
                        capslock = "layer(common)";
                    };

                    common = {
                        esc = "`"; 
                        z = "102nd"; # \
                        p = "G-102nd"; # |
                        d = "delete";
                        i = "insert";
                        c = "capslock";
                    };
                };
            };
        };
        environment.systemPackages = with pkgs; [ pkgs.keyd ];
    };
}
