{
    description = "Config for home manager";

    inputs = {
        conf.url = "github:AdamDunmore/NixConfigs";
    };

    outputs = { conf, self, ... }: {
        homeConfigurations.default = conf.homeConfigurations.default;
    };

}
