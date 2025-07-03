{
    description = "Nix Configs designed to run on any unix system";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        nixpkgs-24_11.url = "github:nixos/nixpkgs/nixos-24.11";

        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";

        jovian.url = "github:Jovian-Experiments/Jovian-NixOS";
        jovian.inputs.nixpkgs.follows = "nixpkgs";

        spicetify-nix.url = "github:Gerg-L/spicetify-nix";
        spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";
        nix-flatpak.url = "github:gmodena/nix-flatpak";
        mnw.url = "github:Gerg-L/mnw";
        sops-nix.url = "github:Mic92/sops-nix";
        ags.url = "github:Aylur/ags";
    };

    outputs = { ... } @inputs:
    let
        hosts = [
            "laptop"
            "desktop"
            "steamdeck"
        ];

        systems = [
            "x86_64-linux"
        ];

        users = [
            "adam"
        ];

        templates = [
            "nixos"
            "home"
        ];

        forEachTemplate = inputs.nixpkgs.lib.genAttrs templates; 
        forEachSystem = inputs.nixpkgs.lib.genAttrs systems;
        forEachHost = inputs.nixpkgs.lib.genAttrs hosts;
        forEachUser = inputs.nixpkgs.lib.genAttrs users;

        local = {
            username = "adam";
            system = "x86_64-linux";
            stable_version = "24.11";
        };

        pkgs = import ./utils/pkgs.nix { nixpkgs = inputs.nixpkgs; system = local.system; };
        system = local.system;

        colours = import ./values/colours.nix;
        font = import ./values/font.nix;
    in
    {             
        # TODO fix hm
        # homeConfigurations = forEachUser (user: inputs.home-manager.lib.homeManagerConfiguration {
        #     inherit pkgs;
        #     modules = [ ./home ];
        #     extraSpecialArgs = {
        #         inherit local;
        #         inherit inputs;
        #     };
        # });
        #
        # # sudo nix run .#$(host)
        # packages.${local.system}.hm_conf = inputs.self.homeConfigurations.${local.username}.activationPackage; 
        # apps.${local.system} = forEachHost(host: {
        #     type = "app";            
        #     program = "${inputs.self.packages."${local.system}".hm_conf}/activate"; 
        # });

        # sudo nixos-rebuild switch --flake .#$(host)
        nixosConfigurations = forEachHost(host: inputs.nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
                { nixpkgs.pkgs = pkgs; }

                ./host/${host}

                ./nixos
                
                inputs.home-manager.nixosModules.home-manager {
                    home-manager = {
                        users.${local.username}.imports = [ ./home ];
                        backupFileExtension = "bkp";
                        useGlobalPkgs = true;
                        useUserPackages = true;
                        extraSpecialArgs = {
                                inherit pkgs;
                                inherit host;
                                inherit inputs;
                                inherit local;
                                inherit font;
                                inherit colours;
                        };
                    };
                }
            ];
            specialArgs = {
                inherit system;
                inherit host;
                inherit inputs;
                inherit local;
                inherit font;
                inherit colours;
            };
        });

        # $option = home | nixos
        # nix flake new nix-configs -t github:AdamDunmore/NixConfigs#$option 
        templates = forEachTemplate (template: {
            path = ./template/${template};
        });

        # Jovian ISO
    };
}
