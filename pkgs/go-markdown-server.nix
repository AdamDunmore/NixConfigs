{ pkgs, ... }:
pkgs.buildGoModule {
    pname = "go-markdown-server";
    version = "1.0.0";
    src = pkgs.fetchFromGitHub {
        owner = "nickgrealy";
        repo = "go-markdown-server";
        rev = "72c39c902b21265094326f55f279dffcedcb6b8e";
        sha256 = "sha256-Uv3XsIjWDP83ynD3YOeamub7ahXo0wbS/P8lgikee+I=";
    };
    vendorHash = "sha256-bkeREEO/R2E5WvHXH8ubWRHsro3EEoUe1GgZHOjIYU8=";

    meta = {
        description = "A low memory, <10MB Go web server that serves markdown files converted to HTML.";
        homepage = "https://github.com/nickgrealy/go-markdown-server";
        license = pkgs.lib.licenses.mit;
        maintainers = with pkgs.lib.maintainers; [ nichgrealy ];
    };
}
