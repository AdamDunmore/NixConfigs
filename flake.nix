{
    description = "Nix Configs designed to run on any unix system";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";

        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";

        nixos-hardware.url = "github:NixOS/nixos-hardware/master";
        sops-nix.url = "github:Mic92/sops-nix";
        mnw.url = "github:Gerg-L/mnw";
        waybar.url = "github:alexays/waybar";
        ags.url = "github:Aylur/ags";
        nix-flatpak.url = "github:gmodena/nix-flatpak";
        jovian.url = "github:Jovian-Experiments/Jovian-NixOS";
        spicetify-nix = {
            url = "github:Gerg-L/spicetify-nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        mango = {
            url = "github:ernestoCruz05/mango-ext";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        moonlight = {
            url = "github:moonlight-mod/moonlight";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        watch-me.url = "git+ssh://git@github.com/AdamDunmore/watch-me.git";
    };

    outputs = { ... } @inputs:
    let
        # Options
        hosts = {
            default = [
                { name = "default"; system = "x86_64-linux"; }
            ];
            adam = [
                { name = "laptop"; system = "x86_64-linux"; }
                { name = "desktop"; system = "x86_64-linux"; }
                { name = "steam-deck"; system = "x86_64-linux"; }
            ];
        };

        # Dev
        lib = inputs.nixpkgs.lib;

        derivs = lib.listToAttrs (
            lib.concatLists (
                lib.mapAttrsToList
                    (user: hosts:
                        map (host:
                            lib.nameValuePair "${user}-${host.name}" {
                                inherit user;
                                host = host.name;
                                inherit (host) system;
                            }
                        ) hosts
                    )
                hosts
            )
        );
        forEachDeriv = f: lib.mapAttrs f derivs;
    in
    {             
        # nh home switch .
        # homeConfigurations = forEachUser (user: inputs.home-manager.lib.homeManagerConfiguration {
        #     inherit pkgs;
        #     modules = [ ./home ];
        #     extraSpecialArgs = lib.mergeAttrs arguments.home-manager {
        #             host = "default";
        #             inherit user;
        #     };
        # });

        # nh os switch . --hostname <host>
        nixosConfigurations = forEachDeriv (name: deriv:
            inputs.nixpkgs.lib.nixosSystem {
            system = deriv.system;
            modules = [
                { 
                    nixpkgs.pkgs = import ./utils/pkgs.nix { nixpkgs = inputs.nixpkgs; system = deriv.system; }; 
                    _module.args.pkgs-stable = import ./utils/pkgs.nix { nixpkgs = inputs.nixpkgs-stable; system = deriv.system; };
                }
                ./options/default.nix

                ./users/${deriv.user}/hosts/${deriv.host}/settings.nix
                
                ./users/${deriv.user}/hosts/${deriv.host}
                ./modules/nixos

                inputs.home-manager.nixosModules.home-manager  {
                    home-manager = {
                        users.${deriv.user}.imports = [ 
                            ./options/default.nix
                            ./users/${deriv.user}/hosts/${deriv.host}/settings.nix

                            ./users/${deriv.user}/hosts/${deriv.host}/home.nix

                            ./modules/home
                        ];
                        backupFileExtension = "bkp";
                        useGlobalPkgs = true;
                        useUserPackages = true;
                        extraSpecialArgs = {
                                inherit inputs;
                                inherit (deriv) host user system;
                        };
                    };
                }
            ];
            specialArgs = {
                inherit inputs;
                inherit (deriv) host user system;
            };
        });

        # Devshell
        # nix develop .#install
        # devShells.${system}."install" = pkgs.mkShell {
        #     buildInputs = with pkgs; [
        #         neovim
        #         nh
        #         git
        #     ];
        #     shellHook = ''
        #         echo ""
        #         echo "Welcome to my nix configuration install" 
        #         echo ""
        #         echo "To get started run:"
        #         echo "    sudo nixos-generate-config"
        #         echo "    cp /etc/nixos/hardware-configuration.nix ./host/<host>/"
        #         echo "    nh <os/home> switch . --hostname <host>"
        #     ''; # TODO fix directory
        # };
    };
}
