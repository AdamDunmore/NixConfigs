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

    const [cavaValues, setCavaValues] = createState<number[]>([]);
    const [isInteracting, setIsInteracting] = createState<boolean>(false);

    const MAX_TITLE_LENGTH: number = 20;

    const cava = Cava.get_default();
    const mpris = Mpris.get_default();

    cava.set_bars(8);
    cava.set_framerate(15)

    cava.connect("notify::values", () => {
        setCavaValues(cava.get_values());
    })

    let connected_player: Mpris.Player | null = null;

    const update_track = function(player: Mpris.Player){
            setTitle(player.title.slice(0,MAX_TITLE_LENGTH - 10)); 
            setArtist(player.artist.slice(0,MAX_TITLE_LENGTH)); 
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
        <box valign={1} halign={3} orientation={1} spacing={6} name="Mpris Box" class="sidebar_mpris_window">
            <Gtk.EventControllerMotion
                onLeave={() => {
                    setIsInteracting(false)
                }}
            />
            <overlay>
                <box
                    hexpand
                    vexpand
                    class="sidebar_mpris_art"
                    css={position(p => `
                         background: linear-gradient(
                            to top,
                            @borders ${(p / length())* 100}%,
                            @theme_bg_color ${(p / length())* 100}%
                        );
                        min-width: 250px;
                        min-height: 250px;
                    `)}
                />

                <box $type="overlay">
                    <overlay>        
                        <box
                            hexpand
                            vexpand
                            class="sidebar_mpris_art"
                            css={artUrl(a => `
                                margin: 5px;
                                background: url("${(a ?? "undefined")}");
                                background-size: cover;
                                background-position: center;
                            `)}
                        >
                        </box>
                        <box $type="overlay" orientation={Gtk.Orientation.VERTICAL} halign={Gtk.Align.CENTER} valign={Gtk.Align.CENTER} visible={isInteracting(i => i)}>
                            <label halign={Gtk.Align.CENTER} class="sidebar_mpris_label sidebar_mpris_title" label={title(t => t ?? "No Title")} />
                            <label halign={Gtk.Align.CENTER} class="sidebar_mpris_label sidebar_mpris_artist" label={artist(a => a ?? "No Artist")} />
                            <label halign={Gtk.Align.CENTER} class="sidebar_mpris_label" label={volume(v => ` ${Math.floor(v * 100)}%`)} />                        
                        </box>
                        <centerbox $type="overlay" hexpand vexpand>
                            <box $type="end" class="sidebar_cava_box" valign={Gtk.Align.END} hexpand vexpand>
                                {Array.from({ length: 8 }, (_, i) => (
                                    <box class="sidebar_cava_bar" hexpand valign={Gtk.Align.END}
                                        css={cavaValues(v =>
                                            `min-height: ${(v[i] * 40) + 1}px;`
                                        )}
                                    />
                                ))}
                            </box>
                        </centerbox>
                        <centerbox
                            $type="overlay"
                            hexpand
                            vexpand
                            orientation={Gtk.Orientation.VERTICAL}
                            class="sidebar_mpris_media_overlay"
                            visible={isInteracting(i => !i)}
                        >
                            <Gtk.GestureClick
                                button={Gdk.BUTTON_SECONDARY}
                                onPressed={() => {
                                    setIsInteracting(true)
                                }}
                            />
                            <box $type="center" halign={Gtk.Align.CENTER} valign={Gtk.Align.CENTER} orientation={Gtk.Orientation.VERTICAL} spacing={8}>
                                <button halign={Gtk.Align.CENTER} onClicked={() => { execAsync("rmpc volume +5") }} class="button sidebar_mpris_media" label="󰝝" />
                                <box>
                                    <button hexpand={true} onClicked={() => { execAsync("rmpc prev") }} class="button sidebar_mpris_media" label="" />
                                    <button onClicked={() => { execAsync("rmpc togglepause") }} class="button sidebar_mpris_media" label={playbackStatus(p => p ? "" : "")} />
                                    <button hexpand={true} onClicked={() => { execAsync("rmpc next") }} class="button sidebar_mpris_media" label="" />
                                </box>
                                <button halign={Gtk.Align.CENTER} onClicked={() => { execAsync("rmpc volume -5") }} class="button sidebar_mpris_media" label="󰝞" />
                            </box>
                        </centerbox>
                    </overlay>
                </box>
            </overlay>




            <box spacing={8}>
            </box>
        </box>
    )
}
