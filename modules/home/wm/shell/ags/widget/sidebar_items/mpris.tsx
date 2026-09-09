import { For, createState } from "ags";
import Gtk from "gi://Gtk";
import Gdk from "gi://Gdk";
import { execAsync } from "ags/process";
import Cava from "gi://AstalCava"
import Mpris from "gi://AstalMpris";

export default function MprisItem(){
    const [title, setTitle] = createState<string>("");
    const [artist, setArtist] = createState<string>("");
    const [artUrl, setArtUrl] = createState<string>("");
    const [length, setLength] = createState<number>(0);
    const [playbackStatus, setPlaybackStatus] = createState<boolean>(false);
    const [volume, setVolume] = createState<number>(0);
    const [position, setPosition] = createState<number>(0);
    const [isInteracting, setIsInteracting] = createState<boolean>(false);

    const MAX_TITLE_LENGTH: number = 35;
    let connected_player: Mpris.Player | null = null;

    const mpris = Mpris.get_default();

    const update_track = function(player: Mpris.Player){
            setTitle(player.title.slice(0,MAX_TITLE_LENGTH)); 
            setArtist(player.artist.slice(0,MAX_TITLE_LENGTH - 5)); 
            setArtUrl(player.art_url);
            setLength(player.length);
            setPlaybackStatus(player.playback_status);
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
        player.connect("notify::playback-status", () => { setPlaybackStatus(player.playback_status) });
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
        <box hexpand class="sidebar_mpris_window">
            <Gtk.EventControllerMotion
                onLeave={() => {
                    setIsInteracting(false)
                }}
            />
            <Gtk.GestureClick
                button={Gdk.BUTTON_SECONDARY}
                onPressed={() => {
                    setIsInteracting(true)
                }}
            />
            <Gtk.AspectFrame ratio={1} yalign={0}>
                <overlay>
                    <box hexpand vexpand
                        css={position(p => `
                            background: linear-gradient(
                                to top,
                                @borders ${(p / length())* 100}%,
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

                    <box $type="overlay" orientation={Gtk.Orientation.VERTICAL} halign={Gtk.Align.CENTER} valign={Gtk.Align.START} visible={isInteracting(i => i)}>
                        <label halign={Gtk.Align.CENTER} class="sidebar_mpris_label" label={title(t => t ?? "No Title")} />
                        <label halign={Gtk.Align.CENTER} class="sidebar_mpris_label" label={artist(a => a ? `by ${a}` : "No Artist")} />
                        <label halign={Gtk.Align.CENTER} class="sidebar_mpris_label" label={volume(v => ` ${Math.floor(v * 100)}%`)} />                        
                        <label halign={Gtk.Align.CENTER} class="sidebar_mpris_label" label={position(p => `${Math.floor(p/60).toString().padStart(2, "0")}:${(p % 60).toString().padStart(2, "0")}/${Math.floor(length() / 60).toString().padStart(2, "0")}:${(length() % 60).toString().padStart(2, "0")}`)} />                        
                    </box>

                    <centerbox 
                        $type="overlay"
                        hexpand
                        vexpand
                        orientation={Gtk.Orientation.VERTICAL}
                        visible={isInteracting(i => !i)}
                    >
                        <box $type="center" halign={Gtk.Align.CENTER} valign={Gtk.Align.CENTER} orientation={Gtk.Orientation.VERTICAL} spacing={20}>
                            <button halign={Gtk.Align.CENTER} onClicked={() => { execAsync("rmpc volume +5") }} class="button sidebar_mpris_media" label="󰝝" />
                            <box spacing={20}>
                                <button hexpand={true} onClicked={() => { execAsync("rmpc prev") }} class="button sidebar_mpris_media" label="" />
                                <button onClicked={() => { execAsync("rmpc togglepause") }} class="button sidebar_mpris_media" label={playbackStatus(p => p ? "" : "")} />
                                <button hexpand={true} onClicked={() => { execAsync("rmpc next") }} class="button sidebar_mpris_media" label="" />
                            </box>
                            <button halign={Gtk.Align.CENTER} onClicked={() => { execAsync("rmpc volume -5") }} class="button sidebar_mpris_media" label="󰝞" />
                        </box>
                    </centerbox>
                </overlay>
            </Gtk.AspectFrame>
        </box>
    )
}
