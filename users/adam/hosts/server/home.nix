{ inputs, system, pkgs, ... }:
let
    go-markdown-server = import ../../../../pkgs/go-markdown-server.nix { inherit pkgs; };
in
{
    imports = [ 
        ../../home.nix 
        inputs.webserver.homeManagerModules.default
    ];
    config = {
        home.apps = [ inputs.webserver.packages.${system}.default ]; 

        services.webserver = {
            enable = true;
            environmentVariables = {
                WEBSERVER_IP = "100.99.196.76";
                WEBSERVER_PORT = "1913";
            };
            # TODO add a way to pass a password secret
        };

        systemd.user.services.go-markdown-server = {
            Unit = {
                Description = "Service for go-markdown-server";
                After = [ "network-online.target" ];
            };

            Service = {
                ExecStart = "${go-markdown-server}/bin/go-markdown-server";
                Restart = "on-failure";
                RestartSec = 5;
                Environment = {
                    PORT = "9090";
                    CONTENT_DIR="/home/adam/Notes/";
                };
            };

            Install.WantedBy = [ "default.target" ];
        };
    };
}
