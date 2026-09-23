{ inputs, system, ... }:
{
    imports = [ 
        ../../home.nix 
        inputs.webserver.homeManagerModules.default
    ];
    config = {
        home.apps = [ inputs.webserver.packages.${system}.default ]; 
    };
}
