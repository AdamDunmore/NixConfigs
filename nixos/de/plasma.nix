{ pkgs, lib, config, ... }:
let
    cfg = config.settings.nixos.de.plasma;
in
{
    config = lib.mkMerge [
        ( lib.mkIf cfg { services.desktopManager.plasma6.enable = true; } )
        ({  
            environment.plasma6.excludePackages = with pkgs.kdePackages; [
                konsole
                kate
                elisa
                okular
                kwalletmanager
                dolphin
                gwenview
                ark
                ksystemstats
            ];
        })
    ];
}
