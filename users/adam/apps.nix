{ inputs, pkgs, ... }:

let
    custom-pkgs = import ../../pkgs/default.nix { inherit pkgs; };
in
{
    config.settings.modules.home.apps.misc.flatpak.packages = [
        "io.github.zen_browser.zen"
        "org.vinegarhq.Sober"
        "io.mrarm.mcpelauncher"
        "com.github._0negal.Viper"
            
        # rec { # Amethyst 
        #     appId = "io.github.ChrisDKN.AmethystModManager";
        #     sha256 = "1yy07nqjg4mg73f2py1vm6if675k6adw5nbq5pcbydlis9dpyfzm"; 
        #     bundle = "${pkgs.fetchurl {
        #       url = "https://github.com/ChrisDKN/Amethyst-Mod-Manager/releases/download/v1.3.8/AmethystModManager.flatpak";
        #       inherit sha256;
        #     }}";
        # }
    ];
    config.settings.modules.home.apps.user_apps = with pkgs; [
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
        # openshot-qt #bugs in upstream

        custom-pkgs.amethyst
        custom-pkgs.brave-origin
        custom-pkgs.jackify
        custom-pkgs.wfinfo-ng

        # inputs.watch-me.packages.${system}.default

        vscode # TODO move to module
        logseq
        motrix
        thonny
        bottles
        tor-browser
        beeper
        kdePackages.kdeconnect-kde
        qpwgraph
        cava
        proton-pass
        protonmail-desktop
        proton-vpn
        stremio-linux-shell
        vlc

        qemu
        quickgui
        quickemu

        wineWow64Packages.stable
        winetricks
        gamescope
        vulkan-tools
        steamtinkerlaunch
        rshell 
    ];
}
