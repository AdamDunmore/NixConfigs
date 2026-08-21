{ pkgs, lib, config, ... }:
let
    cfg = config.settings.modules.nixos.keyboard.mappings;
    inherit (lib) mkIf;
in
{
    config = mkIf cfg.enable {
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
        environment.systemPackages = [ pkgs.keyd ];
    };
}
