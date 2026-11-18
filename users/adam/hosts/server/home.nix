{
    imports = [ 
        ../../home.nix 
    ];
    # TODO fix style not applying
    config = {
        home.file.".config/vivify/config.json".text = builtins.toJSON {
            styles = ./vivify-style.css; 
        }; 
    };
}
