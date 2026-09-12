import { createComputed, createState } from "ags";
import Gtk from "gi://Gtk";
import { execAsync } from "ags/process";
import Mpris from "gi://AstalMpris";

export default function MprisItem(){
    const [title, setTitle] = createState<string>("");
    const [artist, setArtist] = createState<string>("");
    const [artUrl, setArtUrl] = createState<string>("");
    const [length, setLength] = createState<number>(0);
    const [playbackStatus, setPlaybackStatus] = createState<boolean>(false);
    const [volume, setVolume] = createState<number>(0);
    const [position, setPosition] = createState<number>(0);
    const [changingVolume, setChangingVolume] = createState<boolean>(false)

    const MAX_TITLE_LENGTH: number = 25;
    let connected_player: Mpris.Player | null = null;

    const mpris = Mpris.get_default();

    function onHover(widget: Gtk.Widget) {
        const motion = new Gtk.EventControllerMotion()
        motion.connect("enter", () => setChangingVolume(true))
        motion.connect("leave", () => setChangingVolume(false))
        widget.add_controller(motion)
    }

    const update_track = function(player: Mpris.Player){
        setTitle(player.title.slice(0,MAX_TITLE_LENGTH)); 
        setArtist(player.artist.slice(0,MAX_TITLE_LENGTH - 5)); 
        setArtUrl(player.art_url);
        setLength(player.length);
        setPlaybackStatus(player.playback_status.toString() === "1")
        setVolume(player.volume);
        setPosition(player.position);
    };

    const connect_to_player = function(player: Mpris.Player){
        player.connect("notify::title", () => { 
            update_track(player);
        })
        player.connect("notify::artist", () => { 
            update_track(player);
        })
        player.connect("notify::playback-status", () => { 
            setPlaybackStatus(player.playback_status.toString() === "1")
        });
        player.connect("notify::volume", () => { setVolume(player.volume) });
        player.connect("notify::position", () => { setPosition(player.position) });
    }

    mpris.connect("notify::players", () => {
        for (let p of mpris.players){
            if (p.identity == "Music Player Daemon"){
                if(connected_player === p) return;
                connected_player = p;
                update_track(p);
                connect_to_player(p);
                return
            }
        }
    });

    return (
        <box hexpand class="sidebar_mpris_window" orientation={Gtk.Orientation.VERTICAL} spacing={5}>
            <box class="sidebar_mpris_label" orientation={Gtk.Orientation.VERTICAL}>
                <label halign={Gtk.Align.CENTER} hexpand label={title(t => t ?? "No Title")} />
                <label halign={Gtk.Align.CENTER} hexpand label={artist(a => a ? `by ${a}` : "No Artist")} />
            </box>
            <Gtk.AspectFrame ratio={1} yalign={0}>
                <overlay>
                    <box hexpand vexpand
                        css={position(p => `
                            background: linear-gradient(
                                to top,
                                @theme_selected_bg_color ${(p / length())* 100}%,
                                @theme_bg_color ${(p / length())* 100}%
                            );
                        `)}
                    />

                    <box $type="overlay"
                        css={artUrl(a => `
                            margin: 5px;
                            background: url("${(a ?? "undefined")}");
                            background-size: cover;
                            background-position: center;
                        `)}
                    />

                    <centerbox 
                        $type="overlay"
                        hexpand
                        vexpand
                        orientation={Gtk.Orientation.VERTICAL}
                    >
                        <box $type="center" halign={Gtk.Align.CENTER} valign={Gtk.Align.CENTER} orientation={Gtk.Orientation.VERTICAL} spacing={20}>
                            <button halign={Gtk.Align.CENTER} onClicked={() => { execAsync("rmpc volume +5") }} class="button sidebar_mpris_media" label="󰝝" $={(self) => { onHover(self)}}/>
                            <box spacing={20}>
                                <button hexpand={true} onClicked={() => { execAsync("rmpc prev") }} class="button sidebar_mpris_media" label="" />
                                <button onClicked={() => { execAsync("rmpc togglepause") }} class="button sidebar_mpris_media" css={changingVolume(c => c ? "font-size: 14px; padding-left: 10px; padding-right: 10px;" : "")} label={createComputed(() => {
                                    if (changingVolume()) {
                                        return `${Math.floor(volume() * 100)}%`
                                    }
                                    return playbackStatus() ? "" : ""
                                })} />
                                <button hexpand={true} onClicked={() => { execAsync("rmpc next") }} class="button sidebar_mpris_media" label="" />
                            </box>
                            <button halign={Gtk.Align.CENTER} onClicked={() => { execAsync("rmpc volume -5") }} class="button sidebar_mpris_media" label="󰝞" $={(self) => { onHover(self)}}/>
                        </box>
                    </centerbox>
                </overlay>
            </Gtk.AspectFrame>
        </box>
    )
}
