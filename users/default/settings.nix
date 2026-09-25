{ pkgs, ... }:

{
    imports = [
        ./apps.nix
    ];
    config = {
        settings = {
           modules = {
                enable = true;
           }; 
        };        
    };
}
