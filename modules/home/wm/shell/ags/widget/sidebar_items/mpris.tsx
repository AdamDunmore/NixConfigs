import { Accessor, createComputed, createState, For } from "ags";
import Gtk from "gi://Gtk";
import { execAsync } from "ags/process";
import Mpris from "gi://AstalMpris";
import Pango from "gi://Pango?version=1.0";

class Track {
    constructor(
        public position: string,
        public title: string,
        public album: string,
        public artist: string,
        public duration: number,
    ) {}
}

export default function MprisItem(){
    const [title, setTitle] = createState<string>("");
    const [artist, setArtist] = createState<string>("");
    const [artUrl, setArtUrl] = createState<string>("");
    const [length, setLength] = createState<number>(0);
    const [playbackStatus, setPlaybackStatus] = createState<boolean>(false);
    const [volume, setVolume] = createState<number>(0);
    const [position, setPosition] = createState<number>(0);
    const [changingVolume, setChangingVolume] = createState<boolean>(false)
    const [loop, setLoop] = createState<boolean>(false);
    const [lyrics, setLyrics] = createState<string>("");
    const [queue, setQueue] = createState<Track[]>([]);

    const [tab, setTab] =createState<string>("queue");

    const MAX_TITLE_LENGTH: number = 25;
    let connected_player: Mpris.Player | null = null;

    const mpris = Mpris.get_default();

    function onHover(widget: Gtk.Widget) {
        const motion = new Gtk.EventControllerMotion()
        motion.connect("enter", () => setChangingVolume(true))
        motion.connect("leave", () => setChangingVolume(false))
        widget.add_controller(motion)
    }

    const updateQueue = function(){
        execAsync("rmpc queue").then(q => {
            const q_json: object[] = JSON.parse(q);
            let new_queue: Track[] = new Array<Track>(100);
            for(let i = 0; i < 100; i++){
                new_queue[i] = new Track(
                    q_json[i]["metadata"]["pos"],
                    q_json[i]["metadata"]["title"],
                    q_json[i]["metadata"]["album"],
                    q_json[i]["metadata"]["artist"],
                    parseInt(q_json[i]["duration"]["secs"])
                )
            }
            setQueue(new_queue.slice(1));

        })
    }

    const update_track = function(player: Mpris.Player){
        setTitle(player.title.slice(0,MAX_TITLE_LENGTH)); 
        setArtist(player.artist.slice(0,MAX_TITLE_LENGTH - 5)); 
        setArtUrl(player.art_url);
        setLength(player.length);
        setPlaybackStatus(player.playback_status.toString() === "1")
        setVolume(player.volume);
        setPosition(player.position);
        setLoop(player.loopStatus > 1);
        updateQueue()
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

        player.connect("notify::loop-status", () => { setLoop(player.loopStatus > 1) });
        player.connect("notify::shuffle-status", () => { setShuffle(player.shuffleStatus < 2) });

        player.connect("notify::lyrics", () => { setLyrics(player.lyrics) });
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
        <box orientation={Gtk.Orientation.VERTICAL} valign={Gtk.Align.START} spacing={10}>
            <box hexpand valign={Gtk.Align.START} class="sidebar_mpris_window" orientation={Gtk.Orientation.HORIZONTAL} spacing={5}>
                <Gtk.AspectFrame ratio={1} yalign={0}>
                    <overlay>
                        <box hexpand vexpand
                            css={position(p => `
                                min-height: 200px;
                                min-width: 200px;
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
                
                <box class="sidebar_mpris_label" orientation={Gtk.Orientation.VERTICAL}>
                    <label halign={Gtk.Align.CENTER} hexpand label={title(t => t ?? "No Title")} />
                    <label halign={Gtk.Align.CENTER} hexpand label={artist(a => a ? `by ${a}` : "No Artist")} />
                    <box orientation={Gtk.Orientation.HORIZONTAL} halign={Gtk.Align.CENTER} spacing={30}>
                       <button label="󰑖" class={ loop(l => "sidebar_mpris_button_misc " + `${l ? "active" : ""}`) } onClicked={() => execAsync("rmpc togglerepeat")} /> 
                       <button label="" class="sidebar_mpris_button_misc" onClicked={() => { execAsync("mpc shuffle").then(_ => updateQueue()) }} /> 
                    </box>
                </box>
            </box>
            <box hexpand vexpand class="sidebar_mpris_window" orientation={Gtk.Orientation.VERTICAL} spacing={5}>
                <button hexpand label={tab(t => t == "lyrics" ? "󰉹" : "")} onClicked={() => { setTab(tab() == "lyrics" ? "queue" : "lyrics") }} />
                <label visible={tab(t => t == "lyrics")} hexpand label={lyrics(l => l != "" ? l : "No Lyrics Available")} />
                <scrolledwindow vexpand css="min-height: 300px;" visible={tab(t => t == "queue")} >
                    <box orientation={Gtk.Orientation.VERTICAL} spacing={5}>
                        <For
                            each={queue}
                        >
                            { (t: Track) => { 
                                    const isPlaying = (v: Track) => { return v.title == title() };
                                    if (parseInt(t.position) - 1 > queue().findIndex(isPlaying)) { return (
                                        <button onClicked={() => execAsync(`rmpc play ${t.position}`)}>
                                            <box vexpand hexpand orientation={Gtk.Orientation.VERTICAL}>
                                                <label halign={Gtk.Align.START} label={t.title} wrap wrapMode={Pango.WrapMode.CHAR} maxWidthChars={10} />
                                                <box>
                                                    <label halign={Gtk.Align.START} label={t.artist} wrap wrapMode={Pango.WrapMode.CHAR} maxWidthChars={10} 
                                                        css={`
                                                            font-size: 12px;
                                                            opacity: 0.8;
                                                        `}
                                                    />
                                                    <label halign={Gtk.Align.START} label={`${Math.floor(t.duration / 60).toString()}:${(t.duration % 60).toString().padStart(2, "0")}`} wrap wrapMode={Pango.WrapMode.CHAR} maxWidthChars={10}
                                                        css={`
                                                            font-size: 12px;
                                                            opacity: 0.8;
                                                        `}
                                                    />
                                                </box>
                                            </box>
                                        </button>
                                    )}
                                else { return ( <box visible={false} /> ); }
                            }}
                        </For>
                    </box>
                </scrolledwindow>
            </box>
        </box>
    )
}
