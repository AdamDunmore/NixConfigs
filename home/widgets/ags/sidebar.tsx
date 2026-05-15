import { Astal } from "ags/gtk4";
import { createState, createEffect, For } from "ags";
import app from "ags/gtk4/app";
import { execAsync } from "ags/process";
import Cava from "gi://AstalCava"
import Mpris from "gi://AstalMpris";
import Gtk from "gi://Gtk";

const { TOP, RIGHT, BOTTOM } = Astal.WindowAnchor

export default function Sidebar(){ 
    const [player, setPlayer] = createState({});
    const [isVisible, setIsVisible] = createState(false);
    const [isWindowVisible, setIsWindowVisible] = createState(false);
    const [cavaValues, setCavaValues] = createState([]);

    const cava = Cava.get_default();
    const mpris = Mpris.get_default();

    const MAX_TITLE_LENGTH: number = 30;
    const TRANSITION_LENGTH: number = 500;
    const CAVA_BARS: number = 12;

    const toggleCalled = () => {
        const v_status = isWindowVisible();
        if (!v_status) {
            setIsWindowVisible(!v_status);        
            setTimeout(() => { setIsVisible(!v_status) }, 1)
        } else{
            setIsVisible(!v_status);
            setTimeout(() => { setIsWindowVisible(!v_status) }, TRANSITION_LENGTH / 2)
        }
    };

    app.connect("request", (app, [cmd, arg, ...rest], response) => {
      if (cmd === "toggle_sidebar") {
          toggleCalled()
      }
    })

    const updatePlayer = (p) => {
        setPlayer({
            title: p.title.slice(0,MAX_TITLE_LENGTH - 10),
            artist: p.artist.slice(0,MAX_TITLE_LENGTH),
            artUrl : p.artUrl.replace("file://", ""),
            playbackStatus : p.playbackStatus,
            volume: p.volume,
            length: p.length,
            position: p.position
        });
    };

    cava.set_bars(CAVA_BARS);
    const fake_bars_arr = new Array(CAVA_BARS);
    for (let x = 0; x < CAVA_BARS; x++) { fake_bars_arr.push(x); }
    cava.connect("notify::values", () => {
        setCavaValues(cava.get_values());
    })

    mpris.connect("notify::players", () => {
        for (let p of mpris.players){
            if (p.identity == "Music Player Daemon"){
                updatePlayer(p);
                p.connect("notify", () => {
                    updatePlayer(p);
                })
                return
            }
        }
    });

    return (
        <window visible={isWindowVisible(v => v)} name="sidebar" $={(self) => app.add_window(self)} anchor={TOP | RIGHT | BOTTOM }>
            <revealer
                class = "window"
                revealChild={isVisible(v => v)}
                transitionDuration={TRANSITION_LENGTH}
                transitionType={Gtk.RevealerTransitionType.SLIDE_RIGHT}
            >
                <box orientation={1} vexpand={true}>
                    <box valign={1} halign={3} orientation={1} spacing={6} name="Mpris Box">
                        <box
                            hexpand={true}
                            vexpand={true}
                            class="sidebar_mpris_art"
                            css={player(p => `
                                background: url("file://${(p?.artUrl ?? "undefined")}");
                                background-size: cover;
                                background-position: center;
                            `)}
                        >
                            <For each={cavaValues}>
                                { (v) => {
                                    return (<box class="sidebar_cava_bar" hexpand={true} valign={Gtk.Align.END} css={`min-height: ${(v * 20) + 1}px;`} />)
                                }}
                            </For>
                        </box>
                        <label class="sidebar_mpris_title background_label" label={player(p => p?.title ?? "No Title")}/>
                        <label class="sidebar_mpris_artist background_label" label={player(p => p?.artist ?? "No Artist")} />
                        <levelbar value={player(p => (p?.position / p?.length))} />
                        <box spacing={8}>
                            <button hexpand={true} onClicked={() => { execAsync("rmpc prev") }} class="button" label="" />
                            <button hexpand={true} onClicked={() => { execAsync("rmpc togglepause") }} class="button" label={player(p => p?.playbackStatus ? "" : "")} />
                            <button hexpand={true} onClicked={() => { execAsync("rmpc next") }} class="button" label="" />
                        </box>
                        <box spacing={8}>
                            <button hexpand={true} onClicked={() => { execAsync("rmpc volume -5") }} class="button" label="󰝞" />
                            <label class="sidebar_volume_label background_label" label={player(p => `${p.volume * 100}%`)} />                        
                            <button hexpand={true} onClicked={() => { execAsync("rmpc volume +5") }} class="button" label="󰝝" />
                        </box>
                    </box>

                    <button valign={2} hexpand={true} onClicked={() => {execAsync("togglenight") }} class="button" label="" />
                    <box valign={2}>
                        <button hexpand={true} onClicked={() => { execAsync("hyprlock") }} class="sidebar_power_button" label="" />
                        <button hexpand={true} onclicked={() => { execAsync("systemctl suspend") }} class="sidebar_power_button" label="󰤄" />
                        <button hexpand={true} onclicked={() => { execAsync("reboot") }} class="sidebar_power_button" label="󰜉" />
                        <button hexpand={true} onClicked={() => { execAsync("shutdown now") }} class="sidebar_power_button" label="⏻" />
                    </box>
                </box>
            </revealer>
        </window>
    )
}


