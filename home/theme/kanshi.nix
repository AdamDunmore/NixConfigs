{ lib, config, ... }:
let
    cfg = config.settings.home.theme;
in
{
    config = lib.mkIf cfg {
        services.kanshi = {
            enable = true;
            settings = [
                {
                    profile.name = "PC";
                    profile.outputs = [
                        {
                            criteria = "LG Electronics 24EA53 0x01010101";
                            mode = "1920x1080@60Hz";
                            position = "0,0";
                        }

                        {
                            criteria = "Microstep MSI G323CV DC3M022700075";
                            mode = "1920x1080@75Hz";
                            position = "1920,0";
                        }

                        {
                            criteria = "AOC 2460G5 0x0002FE34";
                            mode = "1920x1080@75Hz";
                            position = "3840,0";
                        }
                    ];
                }

                {
                    profile.name = "PC_Steamdeck_Docked";
                    profile.outputs = [
                        {
                            criteria = "LG Electronics 24EA53 0x01010101";
                            mode = "1920x1080@60Hz";
                            position = "0,0";
                        }

                        {
                            criteria = "Microstep MSI G323CV DC3M022700075";
                            mode = "1920x1080@75Hz";
                            position = "1920,0";
                        }
                    ];
                }

                {
                    profile.name = "Laptop";
                    profile.outputs = [
                        {
                            criteria = "BOE 0x0872 Unknown";
                            mode = "1920x1080@60Hz";
                            position = "0,0";
                        }
                    ];
                }

                {
                    profile.name = "Steamdeck_Undocked";
                    profile.outputs = [
                        {
                            criteria = "Valve Corporation ANX7530 U 0x00000001";
                            mode = "800x1280@90Hz";
                            position = "0,0";
                        }
                    ];
                }

                {
                    profile.name = "Steamdeck_Docked";
                    profile.outputs = [
                        {
                            criteria = "Valve Corporation ANX7530 U 0x00000001";
                            mode = "800x1280@90Hz";
                            position = "0,0";
                        }

                        {
                            criteria = "AOC 2460G5 0x0002FE34";
                            mode = "1920x1080@75Hz";
                            position = "1920,0";
                        }
                    ];
                }
            ];
        };
    };
}
