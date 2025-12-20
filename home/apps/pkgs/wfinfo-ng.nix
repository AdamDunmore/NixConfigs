{ pkgs, ... }:

pkgs.rustPlatform.buildRustPackage rec {
    pname = "wfinfo-ng";
    version = "0.2.23";
    src = pkgs.fetchFromGitHub {
        owner = "knoellle";
        repo = pname;
        rev = "c440b6b5a816270ac2eb4885fa193e19ce607864";
        sha256 = "sha256-qXFpwoVp3qPWPCUsRxBbL3P111sWsq1CELwh9mBUit8=";
    };
    doCheck = false;
    cargoHash = "sha256-qz4hKQP9+FcsmboHsEbR+Z19aWD65Ytj8iQVyYphQYA=";
    nativeBuildInputs = with pkgs; [
        pkg-config
        cmake
        rustPlatform.bindgenHook
    ];
    buildInputs = with pkgs; [
        mesa
        libGL
        openssl
        dbus
        fontconfig
        leptonica
        openssl
        tesseract
        xorg.libX11
        xorg.libXcursor
        xorg.libXi
        xorg.libXrandr
        xorg.libXtst
        libxcb
    ];
}
