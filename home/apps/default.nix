{ pkgs, lib, config, ... }:

let
    cfg = config.settings.home.apps.level;
    inherit (lib) mkIf mkMerge;

    jackify = import ./pkgs/jackify.nix { inherit pkgs; };
    wfinfo-ng = import ./pkgs/wfinfo-ng.nix { inherit pkgs; };
in
{
    imports = [
        ./autostart.nix

        ./browser
        ./misc
        ./music
    ];

    config = mkMerge [
        (mkIf (cfg == "all") { #All
            home.packages = (with pkgs; [
                scanmem
                lutris
                heroic
                prismlauncher
                android-studio
                arduino-ide
                obs-studio
                godot_4
                parsec-bin
                alvr
                jackify
                wfinfo-ng
            ]);
        })

        (mkIf (cfg == "all" || cfg == "light") { #Light
            home.packages = (with pkgs; [
                tidal-hifi
                spicetify-cli
                vscode
                logseq
                motrix
                protonvpn-gui
                thonny
                bottles
                tor-browser
                beeper
                syncthing
                kdePackages.kdeconnect-kde
                discord
                helvum
                cava


                # Sway
                wl-clipboard
                swaysome
                grim
                slurp
                wpaperd
                wofi
                kanshi

                # Gnome
                nautilus
                eog
                file-roller
                gnome-system-monitor
                gnome-calculator
                gnome-settings-daemon


                wineWowPackages.stable
                winetricks
                gamescope
                vulkan-tools
                steamtinkerlaunch
                rshell 
            ]);
        })

        (mkIf (cfg == "all" || cfg == "light" || cfg == "minimal") { #Minimal
            home.packages = (with pkgs; [
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
            ]);
        })
    ];
}
