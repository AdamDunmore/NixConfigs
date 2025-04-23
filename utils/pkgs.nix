{ nixpkgs, system, ... }: 
import nixpkgs {
    inherit system;
    overlays = [
        (final: prev: {
            tidal-hifi = prev.tidal-hifi.overrideAttrs (attrs: {
                version = "5.18.2";
                src = final.fetchurl {
                    url = "https://github.com/Mastermindzh/tidal-hifi/releases/download/5.18.2/tidal-hifi_5.18.2_amd64.deb";
                    sha256 = "sha256-jo3vnq7ul7e+UsaBswil8EctUxVJMcTxo77YyQ2ncIM=";
                };
            });
        })
    ];
    config = {
        permittedInsecurePackages = [
            "electron-27.3.11"
        ];
        allowUnfree = true;
        allowBroken = true;
    };
}
