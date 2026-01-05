{ pkgs, ... }:

pkgs.stdenv.mkDerivation rec {
    pname = "jackify";
    version = "0.2.0.10";

    src = pkgs.fetchFromGitHub {
        owner = "Omni-guides";
        repo = "Jackify";
        rev = "9b5310c2f93190efd94225a8d47dbc8d29686622";
        sha256 = "sha256-OA3uIciM/+KK9HiBcsJZfwF7UqOS5WL4hkCxswQRtlA=";
    };

    nativeBuildInputs = with pkgs; [
        makeWrapper
        autoPatchelfHook
    ];

    autoPatchelfIgnoreMissingDeps = [
        "liblttng-ust.so.0"
    ];


    buildInputs = with pkgs; [
        python313
    ];

    propagatedBuildInputs = with pkgs.python313Packages; [
        pyside6
        psutil
        requests
        tqdm
        pycryptodome
        pyyaml
        vdf
        packaging
        shiboken6
        urllib3
        idna
        certifi
    ];


    installPhase = ''
    mkdir -p $out/lib/jackify
    cp -r . $out/lib/jackify

    makeWrapper ${pkgs.python313}/bin/python \
      $out/bin/jackify \
      --add-flags "-m jackify" \
      --prefix PYTHONPATH : ${
        pkgs.lib.makeSearchPath pkgs.python313.sitePackages propagatedBuildInputs
      } \
      --prefix PYTHONPATH : "$out/lib/jackify"
  '';

}

