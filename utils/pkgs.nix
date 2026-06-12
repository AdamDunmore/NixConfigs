{ nixpkgs, system, ... }: 
import nixpkgs {
    inherit system;
    config = {
        permittedInsecurePackages = [
            "electron-27.3.11"
            "electron-39.8.10"
        ];
        allowUnfree = true;
        allowBroken = true;
    };
}
