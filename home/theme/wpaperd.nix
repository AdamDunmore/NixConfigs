{
    config = {
        programs.wpaperd = {
            enable = true;
            settings = {
                any = {
                    path = ../../wallpapers;
                    duration = "10m";
                    sorting = "random";
                };
            };
        };
    };
}
