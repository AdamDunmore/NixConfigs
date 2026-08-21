{ pkgs, ... }:

let
desktopItem = pkgs.makeDesktopItem {
    name = "brave-origin-nightly";
    desktopName = "Brave Nightly";
    exec = "brave-origin-nightly %U";
    icon = "brave-browser-nightly";
    terminal = false;
    categories = [ "Network" "WebBrowser" ];
  };
in
pkgs.stdenv.mkDerivation rec {
    pname = "brave-origin-nightly-bin";
    version = "1.94.10";

    src = pkgs.fetchurl {
        url = "https://github.com/brave/brave-browser/releases/download/v${version}/brave-origin-nightly-1.94.10-1.x86_64.rpm";
        sha256 = "sha256-btzeH3KWBAlB7W9u26mt4igXHBZ1n1t/qZuw0cjAxgM=";
    };

    nativeBuildInputs = with pkgs; [
        rpm
        cpio
        autoPatchelfHook
        makeWrapper
        qt6.wrapQtAppsHook
    ];

    dontConfigure = true;
    dontBuild = true;
    dontStrip = true;

    unpackPhase = ''
        set +e

        ${pkgs.rpm}/bin/rpm2cpio "$src" | ${pkgs.cpio}/bin/cpio -idmv
        set -e

        ls -la
    '';

    buildInputs = with pkgs; [
        glib
        nspr
        nss
        atk
        at-spi2-atk
        dbus
        cups
        expat
        libxkbcommon
        alsa-lib
        mesa
        libdrm

        libX11
        libXext
        libXcomposite
        libXdamage
        libXfixes
        libXrandr
        libxcb

        cairo
        pango

        systemd

        qt6.qtbase
    ];

    installPhase = ''
        mkdir -p $out/bin
        mkdir -p $out/opt/brave.com/brave-origin-nightly


        cp -a opt/brave.com/brave-origin-nightly/. $out/opt/brave.com/brave-origin-nightly/
  

        chmod +x $out/opt/brave.com/brave-origin-nightly/brave


        ln -s $out/opt/brave.com/brave-origin-nightly/brave $out/bin/brave-origin-nightly


        mkdir -p $out/share/applications
        cp ${desktopItem}/share/applications/* $out/share/applications/
    '';

    preFixup = ''
        rm $out/opt/brave.com/brave-origin-nightly/libqt5_shim.so
        rm $out/opt/brave.com/brave-origin-nightly/libqt6_shim.so
    '';

    runtimeDependencies = with pkgs; [
        gtk3
        nss
        nspr
        cups
        libdrm
        mesa
        alsa-lib
        dbus
        xorg.libX11
    ];
}

