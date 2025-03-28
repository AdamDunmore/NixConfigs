{
    config = {
        services.kanshi = {
            enable = true;
            settings = [
                {
                    profile.name = "PC";
                    profile.outputs = [
                        {
                            criteria = "LG Electronics 24EA53 ";
                            mode = "1920x1080@60Hz";
                            position = "0,0";
                        }

                        {
                            criteria = "Microstep MSI G323CV DC3M02270
    0075";
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
                    profile.name = "Laptop";
                    profile.outputs = [
                        {
                            criteria = "BOE 0x0872 Unknown";
                            mode = "1920x1080@60Hz";
                            position = "0,0";
                        }
                    ];
                }
            ];
        };
    };
}
