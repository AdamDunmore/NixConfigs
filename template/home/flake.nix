{
    description = "Config for home manager";

    inputs = {
        conf.url = "github:AdamDunmore/NixConfigs";
    };

    outputs = { conf, self, ... }:
    let
        local = {
            username = "user";
            system = "x86_64-linux";
            stable_version = "24.11";
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
        packages."${local.system}".hm_conf = self.homeConfigurations."${local.username}".activationPackage;
 
        # sudo nix run .#default
        apps."${local.system}".default = {
            type = "app";
            program = "${self.packages."${local.system}".hm_conf}/activate"; 
        };
    };

}
