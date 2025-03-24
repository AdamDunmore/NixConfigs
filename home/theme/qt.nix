{ pkgs, ... }:
{
    config = {
        qt = {
            enable = true;
            platformTheme.name = "gtk3";
            style = {
                name = "Nordic";
                package = pkgs.nordic;
            };
        };
    };
}
