{ lib, config, ... }:
let
    cfg = config.settings.modules.home.apps.misc.drive;
    inherit (lib) mkIf;
in
{
    config = mkIf cfg.enable {
        # Creates drive directory
        home.activation.createDriveDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
            mkdir -p "$HOME/Drive"
            mkdir -p "$HOME/University"
        '';

        programs.rclone = {
            enable = true;
            remotes =  {
                drive = {
                    config.type = "drive"; 
                    secrets = {
                        token = "/run/secrets/drive_token";
                    };
                    mounts."store" = {
                        enable = true;
                        autoMount = true;
                        mountPoint = "${config.home.homeDirectory}/Drive";
                    };
                };

                onedrive = let 
                    fedAuth = "77u/PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiPz48U1A+VjE1LDBoLmZ8bWVtYmVyc2hpcHwxMDAzMjAwNjEzZjY5OTY1QGxpdmUuY29tLDAjLmZ8bWVtYmVyc2hpcHwyNjA4NTc2QHVhZC5hYy51aywxMzQzMzY0MDE0OTAwMDAwMDAsMTM0MjgwOTQ0OTMwMDAwMDAwLDEzNDM0OTgyMTE0MjMzODAzMCw4Mi4xMzIuMjE3LjEwOSw2NyxkNjA4ZTc4ZC1jNWYyLTQ0YjAtOWI5ZS1mYjIwZGZlN2I4ZDIsLDAwOGIwOWRhLTlkMjMtYjU1ZC00ZjI3LWI4NzQ3NDQxN2ViNyxjY2IwM2RhMi04MDc5LTMwMDEtNjJhYy02NzUyYzVlNTc2NWEsY2NiMDNkYTItODA3OS0zMDAxLTYyYWMtNjc1MmM1ZTU3NjVhLCwwLDEzNDM0NTUzNzE0MTkwNjQxNCwxMzQzNDgwOTMxNDE5MDY0MTQsLCxleUpqWVhCdmJHbGtjMTlzWVhSbFltbHVaQ0k2SWx0Y0lqVmtPR1poWWpnM0xUaG1ZbU10TkdWaVppMWlNams1TFRnMVpERmhZelJsTVRSbU5sd2lYU0lzSW5odGMxOWpZeUk2SWx0Y0lrTlFNVndpWFNJc0luaHRjMTl6YzIwaU9pSXhJaXdpY0hKbFptVnljbVZrWDNWelpYSnVZVzFsSWpvaU1qWXdPRFUzTmtCMVlXUXVZV011ZFdzaUxDSjFkR2tpT2lKMlJteDNSbmt4ZVVzd2NTMXBRMjlrUmsxTkxVRkJJaXdpWVhWMGFGOTBhVzFsSWpvaU1UTTBNek0yTkRBeE5Ea3dNREF3TURBd0luMD0sMjY1MDQ2Nzc0Mzk5OTk5OTk5OSwxMzQzNDU1MDEwMjAwMDAwMDAsNzk5Zjg1MTEtMjI3YS00NmQxLWE0MDktYTcyZDljMzJjYzVmLCwsLCwsMTE1MjkyMTUwNDYwNjg0Njk3NiwsMTg4MDE1LFNEbl9DUUx5RVFReG00dlVLVno0QzlFc2Y0NCwsMCwsMmdaNWxtMC9Lc2tGY0RyZDN1ZDNOaGs5UU1RN1R4c0dta21mclJ5d3E2blV6cUNGVks3SEh0MzZDREk2WkdubWh3NU1IV3NvNk4ybmNNbXBjb2ZiZzVDYnk3SXB1SjFpS2JyZ1Y1engydnp5RVNzYVZlYjZPQlNTRHZPdXNzNElYQzlnYkhHb01oVVl5L3F4Qms2d1ZCVnF6UHRwWDFmemkrd1dwWnlBUCs1TW4xRmdrbkZjVXFvbE01Q01XOCtXcCtFTWgvZWg3UUY5K0NQK1JWZk9iQm4zT21qRDRtekpNQ3diOFdaajRwbWc2aEFxQ2RWd1EwYmVPNWtEM0FRRngzNmNTaGpWMzVsUEdlTUZ1VldBY2dBZGFKQXJHdnhISG9kU2g2TkFsYmxMMU40dlFFZkp4NFZmek5GVDZGeGFKSlNJeGpXV0M5MVVHUldydzVhY0R3PT08L1NQPg==";
                    rtFa = "oYrgc2nvP+JUp7+2jIsUDj78ir3sDul9/IiSyT4NxQ8mZDYwOGU3OGQtYzVmMi00NGIwLTliOWUtZmIyMGRmZTdiOGQyIzEzNDM0NTUwMTE0MjY5NzU1NSNjY2IwM2RhMi00MDU2LTMwMDEtNjJhYy02NmNiMGMxY2JhMTkjMjYwODU3NiU0MHVhZC5hYy51ayMxODgwMTUjWHhINHNWUTdJeHRZVzNaeDNUSTFXWS1YbXQ4I1h4SDRzVlE3SXh0WVczWngzVEkxV1ktWG10OCFCsLfBK9h2rPppWcmOgFt5BjVrQV6Vve+OhKN6ohklDzj0ejwvKEuwYhvtZk9fUAjeT/yYIkbnhcy7pXl/cLM7xO9PxP6zAmcuqrob32whhDLsfbnJyVpCOCWrjm4ywubh227BpTyay6KCXvuI/IARCtULbBjxkfqVcGIl+4SAqmimGIWMLBxtvJXOs7WJJIrn4As+Wuqkk2kT+xU6WJOoSOThUJ92fMraixPkUkQwa1R14ru4QKoQCJ/oGIran9R5MiX8NgX2rA3+ga2AAPO1uLnuUKFqr/vGbQPH19fohALG0IjJIWBuWZCiuN6FDZNdzl2nrps7F6+0Oi6/CcXQAAAA";
                in {
                    config = {
                        type = "webdav";
                        url = "https://liveabertayac-my.sharepoint.com/personal/2608576_uad_ac_uk/Documents";
                        vendor = "other";
                        user = "2608576@uad.ac.uk";
                        headers = "\"Cookie\",\"FedAuth=${fedAuth};rtFa=${rtFa}\"";
                    };
                    secrets = {
                        pass = "/run/secrets/onedrive_pass";
                    };
                    mounts."" = {
                        enable = true;
                        autoMount = true;
                        mountPoint = "${config.home.homeDirectory}/University";
                        options = {
                            vfs-cache-mode = "full";
                        };
                    };
                };
            };
        };
    };
}
