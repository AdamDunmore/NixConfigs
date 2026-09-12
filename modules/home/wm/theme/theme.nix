{ pkgs, colours }:

let
    lib = pkgs.lib;
    oomox = pkgs.fetchFromGitHub {
        owner = "themix-project";
        repo = "oomox-gtk-theme";
        rev = "master";
        hash = "sha256-5wULeGims7/QzLeuk8YSFhJHpUPWioByH2AqzZkXO7Q=";
    };

    hex = colour:
        lib.removePrefix "#" colour;

    palette = pkgs.writeText "gtk-palette" ''
        BG=${hex colours.bg}
        FG=${hex colours.fg}

        SEL_BG=${hex colours.bg_selected}
        SEL_FG=${hex colours.fg_selected}

        ACCENT_BG=${hex colours.bg_selected}

        TXT_BG=${hex colours.base}
        TXT_FG=${hex colours.fg}

        HDR_BG=${hex colours.bg}
        HDR_FG=${hex colours.fg}

        BTN_BG=${hex colours.bg}
        BTN_FG=${hex colours.fg}

        HDR_BTN_BG=${hex colours.bg_selected}
        HDR_BTN_FG=${hex colours.fg_selected}

        WM_BORDER_FOCUS=${hex colours.border}
        WM_BORDER_UNFOCUS=${hex colours.border}

        ROUNDNESS=2
        OUTLINE_WIDTH=1
        BTN_OUTLINE_WIDTH=1
        BTN_OUTLINE_OFFSET=-3
        SPACING=3
        GRADIENT=0

        GTK3_GENERATE_DARK=True
    '';
in
pkgs.stdenvNoCC.mkDerivation {
    pname = "gtk-generated";
    version = "1.0";

    src = oomox;

    nativeBuildInputs = with pkgs; [
        bash
        bc
        coreutils
        findutils
        gnused
        sassc
        glib
        gdk-pixbuf
        librsvg
        gtk3
    ];

    dontBuild = true;

    postPatch = ''
        find . -type f -name '*.sh' -exec sed -i \
            '1s|^#!/usr/bin/env bash$|#!${pkgs.bash}/bin/bash|' {} +
    '';

    installPhase = ''
        export HOME="$TMPDIR/home"
        mkdir -p "$HOME"

        ./change_color.sh \
            --output GTK-Generated \
            --target-dir "$TMPDIR/themes" \
            --make-opts gtk3 \
            "${palette}"

        mkdir -p "$out/share/themes"
        cp -r "$TMPDIR/themes/GTK-Generated" \
        "$out/share/themes/GTK-Generated"
    '';
}
