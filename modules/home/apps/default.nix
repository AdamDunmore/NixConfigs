{ config, lib, pkgs, user, ... }:
let
    cfg = config.settings.modules.home.apps;
    inherit (lib) mkIf;
in
{
    imports = [
        ./media
        ./scripts
        ./misc

        ../../../users/${user}/apps.nix
    ];
    config = mkIf cfg.enable {
        home.packages = with pkgs; [
                firefox

                # Git
                git
                git-credential-manager

                # Tools
                bat
                p7zip
                networkmanager
                brightnessctl
                blueman
                bluez
                zip
                unzip
                killall
                htop
                wget
                fd
                ripgrep
                jq
                fzf
                home-manager
                sops
                pulseaudio
                playerctl
                usbutils
                lsof

                # Languages
                typescript
                dotnet-sdk_9
                zig
                zulu8
                libgccjit
                cargo
                nodejs_22
                dart

                #Libs
                tree-sitter
                geckodriver
                libratbag
                yad
                python3
                pkg-config
                pango
                binutils 
                libnotify
                ffmpeg_6  
        ] ++ cfg.user_apps;
    }; 
}
