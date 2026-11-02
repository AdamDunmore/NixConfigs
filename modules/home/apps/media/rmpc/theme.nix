{ pkgs, colours }:
pkgs.writeTextFile {
    name = "rmpc-theme.ron";
    text = ''
        #![enable(implicit_some)]
        #![enable(unwrap_newtypes)]
        #![enable(unwrap_variant_newtypes)]
        (
            show_song_table_header: true,
            draw_borders: true,
            format_tag_separator: " | ",
            browser_column_widths: [20, 38, 42],

            background_color: "${colours.base}",
            text_color: "${colours.fg}",
            header_background_color: "${colours.bg}",

            tab_bar: (
                enabled: true,
                active_style: (
                    fg: "${colours.fg_selected}",
                    bg: "${colours.bg_selected}",
                    modifiers: "Bold",
                ),
            ),

            symbols: (
                song: "󰎇",
                dir: "󱍙",
                playlist: "󰎄",
                marker: " ",
                ellipsis: "...",
            ),

            progress_bar: (
                symbols: ["", "█", "", " ", ""],
            ),

            scrollbar: (
                symbols: ["│", "█", "▲", "▼"],
            ),

            song_table_format: [
                (
                    prop: (
                        kind: Property(Title),
                        default: (kind: Text("Unknown")),
                    ),
                    width: "40%",
                ),
                (
                    prop: (
                        kind: Property(Album),
                        style: (fg: "${colours.fg_selected}"),
                        default: (
                            kind: Text("Unknown Album"),
                            style: (fg: "${colours.fg_selected}"),
                        ),
                    ),
                    width: "30%",
                ),
                (
                    prop: (
                        kind: Property(Artist),
                        default: (kind: Text("Unknown")),
                    ),
                    width: "20%",
                ),
                (
                    prop: (
                        kind: Property(Duration),
                        default: (kind: Text("-")),
                    ),
                    width: "10%",
                    alignment: Right,
                ),
            ],

            components: {},

            layout: Split(
                direction: Vertical,
                panes: [
                    (
                        pane: Pane(Tabs),
                        size: "3",
                    ),
                    (
                        pane: Split(
                            direction: Horizontal,
                            panes: [
                                (
                                    pane: Split(
                                        direction: Vertical,                
                                        panes: [
                                            (size: "50%", pane: Pane(AlbumArt)), 
                                            (size: "1", pane: Pane(Property(
                                                align: Center,
                                                content: [
                                                    (kind: Property(Song(Title)))
                                                ],
                                            ))),
                                            (size: "1", pane: Pane(Property(
                                                align: Center,
                                                content: [
                                                    (kind: Property(Song(Album)))
                                                ],
                                            ))),
                                            (size: "1", pane: Pane(Property(
                                                align: Center,
                                                content: [
                                                    (kind: Property(Song(Artist)))
                                                ],
                                            ))),
                                            (size: "1", pane: Pane(Property(
                                                align: Center,
                                                content: [
                                                    (kind: Property(Status(Elapsed))),
                                                    (kind: Text("/")),
                                                    (kind: Property(Status(Duration))),
                                                ],
                                            ))),
                                            (size: "1", pane: Pane(Property(
                                                align: Center,
                                                content: [
                                                    (kind: Text("Bit Rate: ")),
                                                    (kind: Property(Song(Bits())))
                                                ],
                                            ))),
                                        ],
                                    ),
                                    size: "30%",
                                ),
                                (
                                    pane: Pane(TabContent),
                                    size: "70%",
                                ),
                            ],
                        ),
                        size: "100%",
                    ),
                    (
                        pane: Pane(ProgressBar),
                        size: "1",
                    ),
                ],
            ),

            header: (
                rows: [
                    (
                        left: [
                            (kind: Text(" ")),
                            (
                                kind: Property(
                                    Status(
                                        StateV2(
                                            playing_label: "",
                                            paused_label: "",
                                            stopped_label: "",
                                        )
                                    )
                                ),
                                style: (modifiers: "Bold"),
                            ),
                            (kind: Text(" ")),
                            (kind: Property(Status(Elapsed))),
                            (kind: Text(" / ")),
                            (kind: Property(Status(Duration))),
                        ],

                        center: [
                            (
                                kind: Property(Song(Title)),
                                style: (modifiers: "Bold"),
                                default: (
                                    kind: Text("No Song"),
                                    style: (modifiers: "Bold"),
                                ),
                            ),
                        ],

                        right: [
                            (kind: Property(Widget(Volume))),
                        ],
                    ),

                    (
                        left: [],

                        center: [
                            (
                                kind: Property(Song(Artist)),
                                default: (kind: Text("Unknown")),
                            ),
                            (kind: Text(" - ")),
                            (
                                kind: Property(Song(Album)),
                                default: (kind: Text("Unknown Album")),
                            ),
                        ],

                        right: [
                            (
                                kind: Property(
                                    Widget(
                                        States(
                                            active_style: (
                                                fg: "${colours.fg_selected}",
                                                modifiers: "Bold",
                                            ),
                                            separator_style: (
                                                fg: "${colours.fg_selected}",
                                            ),
                                        )
                                    )
                                ),
                                style: (fg: "${colours.border}"),
                            ),
                        ],
                    ),
                ],
            ),

            browser_song_format: [
                (
                    kind: Group([
                        (kind: Property(Track)),
                        (kind: Text(" ")),
                    ])
                ),
                (
                    kind: Group([
                        (kind: Property(Artist)),
                        (kind: Text(" - ")),
                        (kind: Property(Title)),
                    ]),
                    default: (kind: Property(Filename)),
                ),
            ],
        )
    '';
}
