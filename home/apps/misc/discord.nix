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
                    betterCodeblocks.enable = true;  
                    betterEmbedsYT.enable = true;      
                    callIdling.enable = true;    
                    callTimer.enable = true;  
                    clearUrls.enable = true;           
                    doubleClickActions.enable = true;             
                    freeMoji.enable = true; 
                    freeScreenShare.enable = true;
                    freeStickers.enable = true;
                    hideBlocked.enable = true;
                    memberCount.enable = true;
                    muteGuildOnJoin.enable = true;
                    noHelp.enable = true;           
                    noJoinMessageWave.enable = true;
                    noPendingCount.enable = true;
                    removeTopBar.enable = true;
                    volumeManipulator.enable = true;
                };
            };
        };
    };
}
