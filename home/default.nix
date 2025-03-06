{ local, inputs, ... }:
{
    imports = [
        ./options.nix
        ../settings.nix

        ./apps
    ];
}
