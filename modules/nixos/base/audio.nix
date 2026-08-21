{ lib, config, ... }:
let
    cfg = config.settings.modules.nixos.base.audio;
    inherit (lib) mkIf;
in
{
    config = mkIf cfg.enable {
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
