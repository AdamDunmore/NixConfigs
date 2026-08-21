{ lib, ... }:
let
    inherit (lib) mkEnableOption;
in
{
    imports = [
        ./home
        ./nixos
    ];
    options.settings.modules = {
        enable = mkEnableOption "Enable modules";
    };
}
