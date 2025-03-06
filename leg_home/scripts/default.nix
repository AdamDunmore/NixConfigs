{ config, lib, ... }:

let
  cfg = config.adam.scripts;
in

{
    config = lib.mkIf cfg {
       home.file.".scripts" = {
            recursive = true;
            source = ./scripts;
        };
    };
}
