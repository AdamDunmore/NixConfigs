{
    description = "Nix Configs designed to run on any unix system";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        nixpkgs-24_11.url = "github:nixos/nixpkgs/nixos-24.11";

        nixos-hardware.url = "github:NixOS/nixos-hardware/master";

        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";

        jovian.url = "github:Jovian-Experiments/Jovian-NixOS";
        jovian.inputs.nixpkgs.follows = "nixpkgs";


        cosmic-manager.url = "github:HeitorAugustoLN/cosmic-manager";
        cosmic-manager.inputs = {
            nixpkgs.follows = "nixpkgs";
            home-manager.follows = "home-manager";
        };
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
            "server"
            "steamdeck"
            "default"
        ];

        users = [
            "adam"
        ];

        templates = [
            "nixos"
            "home"
        ];

        forEachTemplate = inputs.nixpkgs.lib.genAttrs templates;
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
        # nh home switch .
        homeConfigurations = forEachUser (user: inputs.home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [ ./home ];
            extraSpecialArgs = {
                    inherit pkgs;
                    host = "default";
                    inherit inputs;
                    inherit local;
                    inherit font;
                    inherit colours;
            };
        });

        # nh os switch . --hostname <host>
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

        # Devshell
        # nix develop .#install
        devShells."${local.system}"."install" = pkgs.mkShell {
            buildInputs = with pkgs; [
                neovim
                nh
                git
            ];
            shellHook = ''
                echo ""
                echo "Welcome to my nix configuration install" 
                echo ""
                echo "To get started run:"
                echo "    sudo nixos-generate-config"
                echo "    cp /etc/nixos/hardware-configuration.nix ./host/<host>/"
                echo "    nh os switch .#<host>"
            '';
        };

        # Jovian ISO
    };
}
