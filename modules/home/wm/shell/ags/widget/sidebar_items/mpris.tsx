import { For, createState } from "ags";
import Gtk from "gi://Gtk";
import { execAsync } from "ags/process";
import Cava from "gi://AstalCava"
import Mpris from "gi://AstalMpris";

export default function MprisItem(){
    const MAX_TITLE_LENGTH: number = 20;

    const [cavaValues, setCavaValues] = createState<number[]>([]);

    const cava = Cava.get_default();
    const mpris = Mpris.get_default();

    cava.set_bars(8);
    cava.set_framerate(15)

    cava.connect("notify::values", () => {
        setCavaValues(cava.get_values());
    })

    const [title, setTitle] = createState<string>("");
    const [artist, setArtist] = createState<string>("");
    const [artUrl, setArtUrl] = createState<string>("");
    const [length, setLength] = createState<number>(0);
    const [playbackStatus, setPlaybackStatus] = createState<boolean>(false);
    const [volume, setVolume] = createState<number>(0);
    const [position, setPosition] = createState<number>(0);

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
        <box valign={1} halign={3} orientation={1} spacing={6} name="Mpris Box">
            <box
                hexpand={true}
                vexpand={true}
                class="sidebar_mpris_art"
                css={artUrl(a => `
                    background: url("${(a ?? "undefined")}");
                    background-size: cover;
                    background-position: center;
                `)}
            >

            <box class="sidebar_cava_bar" hexpand valign={Gtk.Align.END}
                css={cavaValues((v) => `min-height: ${(v[0] * 20) + 1}px;`)}
            />
            {Array.from({ length: 8 }, (_, i) => (
                <box class="sidebar_cava_bar" hexpand valign={Gtk.Align.END}
                    css={cavaValues(v =>
                        `min-height: ${(v[i] * 20) + 1}px;`
                    )}
                />
            ))}
            </box>
            <label class="sidebar_mpris_title background_label" label={title(t => t ?? "No Title")}/>
            <label class="sidebar_mpris_artist background_label" label={artist(a => a ?? "No Artist")} />
            <levelbar value={position(p => length() > 0 ? p / length() : 0)} />
            <box spacing={8}>
                <button hexpand={true} onClicked={() => { execAsync("rmpc prev") }} class="button" label="" />
                <button hexpand={true} onClicked={() => { execAsync("rmpc togglepause") }} class="button" label={playbackStatus(p => p ? "" : "")} />
                <button hexpand={true} onClicked={() => { execAsync("rmpc next") }} class="button" label="" />
            </box>
            <box spacing={8}>
                <button hexpand={true} onClicked={() => { execAsync("rmpc volume -5") }} class="button" label="󰝞" />
                <label class="sidebar_volume_label background_label" label={volume(v => `${Math.floor(v * 100)}%`)} />                        
                <button hexpand={true} onClicked={() => { execAsync("rmpc volume +5") }} class="button" label="󰝝" />
            </box>
        </box>
    )
}
