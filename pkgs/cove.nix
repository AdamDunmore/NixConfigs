
{ pkgs }:

pkgs.stdenvNoCC.mkDerivation rec {
  pname = "cove";
  version = "1.5.0";

  src = pkgs.fetchurl {
    url = "https://github.com/coveninja/cove/releases/download/v${version}/cove-linux-amd64.tar.gz";
    hash = "sha256-ijcHo2P0pGkUvJPsMSkl2651HmLUWZIlnl4cp6Y9KSI=";
  };

  nativeBuildInputs = with pkgs; [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = with pkgs; [
    mpv
    stdenv.cc.cc.lib
    libGL
    libx11
    libxext
    libxrender
    libxtst
    libxi
    libxrandr
    wayland
  ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    tar -xzf $src -C $out

    substituteInPlace $out/bin/cove \
      --replace-fail "/usr/lib/cove" "$out/lib/cove"

    wrapProgram $out/bin/cove \
      --prefix LD_LIBRARY_PATH : "${pkgs.lib.makeLibraryPath [ pkgs.mpv ]}"

    runHook postInstall
  '';

  dontStrip = true;

  meta = {
    description = "Cross-platform media streaming application";
    homepage = "https://cove.ninja/";
    license = pkgs.lib.licenses.agpl3Plus;
    platforms = [ "x86_64-linux" ];
    mainProgram = "cove";
  };
}

