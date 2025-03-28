{
    description = "Config for Nixos";

    inputs = {
        conf.url = "github:AdamDunmore/NixConfigs";
    };

    outputs = { conf, ... }: {
        nixosConfigurations.default = conf.nixosConfigurations.default;
    };

}
