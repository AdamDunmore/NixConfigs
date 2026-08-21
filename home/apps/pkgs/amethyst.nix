{ pkgs, ... }:

pkgs.python3Packages.buildPythonApplication rec {
    pname = "amethyst-mod-manager";
    version = "1.3.8";

    src = pkgs.fetchFromGitHub {
        owner = "ChrisDKN";
        repo = "Amethyst-Mod-Manager";
        rev = "v${version}";
        hash = "sha256-mRscWjvLOKF/A0ldRn8VAQIUdqywBTfjp2P6bVvkzUg=";
    };

    format = "other";

    postPatch = ''
        sed -i 's/import LOOT.loot as loot/import loot/' 'src/LOOT/loot_sorter.py'
    '';

    nativeBuildInputs = [
        pkgs.python3Packages.wrapPython
        pkgs.wrapGAppsHook3
    ];

    propagatedBuildInputs = with pkgs.python3Packages; [
        tkinter
        pygobject3
        customtkinter
        pycairo
        pillow
        websocket-client
        requests
        keyring
        cryptography
        jeepney
        msgpack
        rarfile
        lz4
        py7zr
        zstandard
      ] ++ [
        pkgs.gdk-pixbuf
        pkgs.gtk3
      ];

    installPhase = ''
        mkdir -p $out/share/${pname}
        cp -r src/* $out/share/${pname}/
        
        # Create the bin directory and the entry point
        mkdir -p $out/bin
        
        # Instead of manual echo/cat, make a simple link or wrapper
        # Nix's wrapPythonPrograms hook will automatically find this
        makeWrapper ${pkgs.python3.interpreter} $out/bin/${pname} \
            --add-flags "$out/share/${pname}/gui.py"
        '';

        # This is the magic line that tells Nix to scan your script
        # and inject the python libraries into its environment
        postFixup = ''
            wrapPythonPrograms
            wrapGAppsHook
        '';
}
