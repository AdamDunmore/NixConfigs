{ inputs, config, lib, pkgs, ... }:
let
    cfg = config.settings.home.apps.misc.discord;
    inherit (lib) mkIf;

    discord = pkgs.discord.override { withMoonlight = true; moonlight = inputs.moonlight.packages.${pkgs.system}.moonlight; };
in
{
    imports = [ inputs.moonlight.homeModules.default ];

    config = mkIf cfg {
        home.packages = [ discord ];
        
        programs.moonlight = {
            enable = false;
            configs.stable = {
                extensions = {

                };
            };
        };
    };
}
