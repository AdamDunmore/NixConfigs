{ pkgs, ... }:

pkgs.rustPlatform.buildRustPackage rec {
    pname = "wfinfo-ng";
    version = "0.1.0";
    src = pkgs.fetchFromGitHub {
        owner = "knoellle";
        repo = pname;
        rev = "c440b6b5a816270ac2eb4885fa193e19ce607864";
        sha256 = "sha256-qXFpwoVp3qPWPCUsRxBbL3P111sWsq1CELwh9mBUit8=";
    };
    doCheck = false;
    cargoHash = "sha256-qz4hKQP9+FcsmboHsEbR+Z19aWD65Ytj8iQVyYphQYA=";
    env = {
        # Fix old CMAKE version
        CMAKE_POLICY_VERSION_MINIMUM = "3.5";
    };
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
        libx11
        libxcursor
        libxi
        libxrandr
        libxtst
        libxcb
    ];
}
