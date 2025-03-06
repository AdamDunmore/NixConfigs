{ config, lib, ... }:

let
  cfg = config.settings.home.scripts;
in

{
    config = lib.mkIf cfg {
       home.file.".scripts" = {
            recursive = true;
            source = ./scripts;
        };
    };
}
