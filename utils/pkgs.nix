{ nixpkgs, system, ... }: 
import nixpkgs {
    inherit system;
    config = {
        permittedInsecurePackages = [
            "electron-27.3.11"
        ];
        allowUnfree = true;
    };
}
