{ lib, config, ... }:
let
    cfg = config.settings.nixos.system.enable;
in
{
    config = lib.mkIf cfg {
        security.rtkit.enable = true;
        services.pipewire = {
            enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
        };
        services.pulseaudio.enable = false;
        services.playerctld.enable = true;
    };
}
