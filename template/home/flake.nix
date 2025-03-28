{
    description = "Config for home manager";

    inputs = {
        conf = "github:AdamDunmore/NixConfigs";
    };

    outputs = { conf }: {
        nixosConfigurations.default = conf.nixosConfigurations.default;
    };

}
