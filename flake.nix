{
    description = "Nix Configs designed to run on any unix system";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        nixpkgs-24_11.url = "github:nixos/nixpkgs/nixos-24.11";

        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";

        spicetify-nix.url = "github:Gerg-L/spicetify-nix";
        spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";
        nix-flatpak.url = "github:gmodena/nix-flatpak";
        mnw.url = "github:Gerg-L/mnw";
    };

    outputs = { ... } @inputs:
    let
        local = {
            username = "adam";
            system = "x86_64-linux";
            stable_version = "24.11";
        };

        system = local.system;
        pkgs = import inputs.nixpkgs { 
            inherit system; 
            config = { 
                permittedInsecurePackages = [ # TODO find a cleaner solution
                    "electron-27.3.11"
                ];
                allowUnfree = true; 
            }; 
        };

    in
    {
        homeConfigurations."${local.username}" = inputs.home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [ ./home ];
            extraSpecialArgs = {
                inherit local;
                inherit inputs;
            };
        };

        packages."${local.system}".hm_conf = inputs.self.homeConfigurations."${local.username}".activationPackage;
 
        apps."${local.system}".default = {
            type = "app";
            program = "${inputs.self.packages."${local.system}".hm_conf}/activate"; 
        };

        # NOTE
        # This is not ready and will not work
        # This is just placeholder for when its implemented
        nixosConfigurations.default = inputs.nixpkgs.lib.nixosSystem {
            modules = [
                ./nixos 

                inputs.home-manager.nixosModules.home-manager {
                    home-manager = {
                        users."${local.username}".imports = [ ./home ];
                        backupFileExtension = "bkp";
                        useGlobalPkgs = true;
                        useUserPackages = true;
                        extraSpecialArgs = {
                                inherit pkgs;
                                inherit inputs;
                                inherit local;
                        };
                    };
                }
            ];            
            specialArgs = {
                inherit system;
                inherit pkgs;
                inherit inputs;
                inherit local;
            };
        };
    };
}
