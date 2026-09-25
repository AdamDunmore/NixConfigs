{ ... }:

{
    imports = [
        ./apps.nix
    ];
    config = {
        settings = {
           modules = {
                enable = true;
                nixos.base.secrets.enable = false;
           }; 
        };        
    };
}
