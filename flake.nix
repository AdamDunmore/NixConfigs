{
    description = "Nix Configs designed to run on any unix system";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        nixpkgs-24_11.url = "github:nixos/nixpkgs/nixos-24.11";

        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";

        nix-flatpak.url = "github:gmodena/nix-flatpak";
    };

    outputs = { ... } @inputs:
    let
        local = {
            username = "adam";
            system = "x86_64-linux";
            stable_version = "24.11";
        };

        pkgs = import inputs.nixpkgs { system = local.system; config = { allowUnfree = true; }; };
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
    };
}
